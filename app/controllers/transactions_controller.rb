class TransactionsController < ApplicationController

  include CurrentUserConcern
  include GiftsHelper
  include TransactionsHelper

  def index
    @transactions = Transaction.all

    render json: {
      transactions: @transactions,
      current_user: @current_user
    }
  end
  
  def create
    shares_number = capital_params["shares_number"].to_i

    transactions = []

    account_balance = IshamiAccountBalance.where(ishami_bank_account_id: 1).first

    if shares_number && shares_number > 0
      i = 1
      while i <= shares_number
        # create purchase
        new_purchase = PurchasesController.new
        transaction_purchase = new_purchase.create(@current_user)
        # create a capital
        # use it to create a transaction;
        new_capital = CapitalsController.new
        transaction_capital = new_capital.create(transaction_purchase);

        if account_balance
          account_balance.update(total_amount: (account_balance.total_amount + transaction_capital.amount))
        else
          account_balance = IshamiAccountBalance.new(total_amount: transaction_capital.amount, saving_amount: 0, ishami_bank_account_id: 1)
          account_balance.save
        end

        @transaction = Transaction.new(capital_id: transaction_capital.id, amount: transaction_capital.amount, transaction_type: "deposit", week_number: 0, ishami_account_balance_id: account_balance.id)

        @transaction.save

        transactions << @transaction
        i += 1
      end

      render json: {
        transactions: transactions
      }, status: :created
    else
      render json: {
        error: "Please specify a number of shares"
      }, status: 422      
    end
  end

  def create_gift_payment(capital)
    new_gift_payment = GiftsController.new
    transaction_gift = new_gift_payment.create(@current_user, capital)

    total_payment = transaction_gift.amount + get_saving_amount(capital) + (transaction_gift.amount * ADMIN_FEE_PERCENT)

    account_balance = IshamiAccountBalance.where(ishami_bank_account_id: 1).first
    account_balance.update(saving_amount: (account_balance.saving_amount + get_saving_amount(capital)), total_amount: (account_balance.total_amount - total_payment), total_gift_amount: (account_balance.total_gift_amount + transaction_gift.amount))

    update_gift_amount_in_purchase(capital, transaction_gift);
    
    @transaction = Transaction.new(capital_id: capital.id, amount: transaction_gift.amount, transaction_type: "payment", gift_id: transaction_gift.id, week_number: 0, ishami_account_balance_id: account_balance.id)
    @transaction.save
    
    update_admin_amount(transaction_gift)

    local_period = 0
    if capital.period == 0
      local_period += 1
    else
      local_period = capital.period + 3
    end

    capital.update(period: local_period, gift_counter: (capital.gift_counter + 1))

    create_saving(capital)
  end

  def create_next_capitals(purchase)
    number_of_capitals = purchase.next_capitals

    account_balance = IshamiAccountBalance.where(ishami_bank_account_id: 1).first
    i = 0
    while i < number_of_capitals
      new_capital = CapitalsController.new
      transaction_capital = new_capital.create(purchase);

      account_balance.update(total_amount: (account_balance.total_amount + transaction_capital.amount), saving_amount: account_balance.saving_amount - transaction_capital.amount)
  
      transaction = Transaction.new(capital_id: transaction_capital.id, amount: transaction_capital.amount, transaction_type: "deposit", week_number: 0, ishami_account_balance_id: account_balance.id)
  
      transaction.save

      i += 1
    end
    purchase.update(next_capitals: 0)
  end

  def recreate_capital(capital)
    new_recreation_date = capital.updated_at.to_s
    new_recreation_date = (Date.parse(new_recreation_date) + 7).to_s

    capital_amount = CAPITAL_AMOUNT
    purchase = capital.purchase

    capital_amount = CAPITAL_AMOUNT_2 if purchase.week_number >= 33

    capital.update(amount: capital_amount, period: 0, gift_counter: 0, recreation_date: new_recreation_date, capital_status: "recreated")

    account_balance = IshamiAccountBalance.where(ishami_bank_account_id: 1).first
    account_balance.update(total_amount: (account_balance.total_amount + capital.amount), total_gift_amount: (account_balance.total_gift_amount - capital_amount))

    update_gift_amount_in_purchase(capital, nil, purchase, capital_amount);

    transaction = Transaction.new(capital_id: capital.id, amount: capital.amount, transaction_type: "deposit", week_number: 0, ishami_account_balance_id: account_balance.id)
  
    transaction.save
    
    render json: {
      capital_updated: capital
    }
  end

  def create_bonuses
    #with the below query, only users who have ever bought a capital will receive bonuses.
    users = User.all.includes(:capitals).where('capital_name = ?', "capital-1").references(:capitals)

    total_bonus = 0;

    users.each do |user|

      user_invites = user.invitees.includes(:capitals)
      user_invitees_capitals = 0
      user_capitals = 0

      user_invites.each do |invite|
        total_capitals = 0
        invite.capitals.each do |capital|
          total_capitals += 1 if capital.capital_name == "capital-1"
        end
        user_invitees_capitals += total_capitals
      end
      
      user_invitation_bonus_amount = determine_bonus_amount(nil, user_invitees_capitals)
      user_invitation_bonus = BonusEarning.new(user_id: user.id, bonus_amount: user_invitation_bonus_amount, bonus_type: "invitation_bonus");
      user_invitation_bonus.save

      user_capitals = user.capitals.length
      user_shares_bonus_amount = determine_bonus_amount(user_capitals)
      user_shares_bonus = BonusEarning.new(user_id: user.id, bonus_amount: user_shares_bonus_amount, bonus_type: "share_bonus");
      user_shares_bonus.save

      total_bonus += (user_invitation_bonus_amount + user_shares_bonus_amount)

    end

    account_balance = IshamiAccountBalance.where(ishami_bank_account_id: 1).first
    account_balance.update(total_bonus_amount: (account_balance.total_bonus_amount + total_bonus))

    admin = AdminAccount.find(1)
    admin.update(total_admin_amount: (admin.total_admin_amount - total_bonus))

  end


  

  #***--- PRIVATE FUNCTIONS START HERE ---***#

  private

  def capital_params
    params.require(:transaction).permit(:shares_number)
  end

  def update_saving_in_purchases(capital)
    purchase = Purchase.where(id: capital.purchase_id).first

    purchase.savings_amount = purchase.savings_amount.to_i if purchase.savings_amount == nil

    purchase.savings_amount += get_saving_amount(capital)

    capital_amount = CAPITAL_AMOUNT
    # capital_amount = CAPITAL_AMOUNT_2 if purchase.week_number >= 33
    
    if purchase.savings_amount >= capital_amount
      purchase.next_capitals = purchase.next_capitals.to_i + 1
      purchase.savings_amount = purchase.savings_amount - capital_amount
    end

    purchase.save
  end

  def update_gift_amount_in_purchase(capital, gift = nil, purchase = nil, capital_amount = nil)

    return if (gift && purchase)

    if gift
      local_purchase = capital.purchase

      local_purchase.update(purchase_gift_amount: (local_purchase.purchase_gift_amount + gift.amount))
    else
      purchase.update(purchase_gift_amount: (purchase.purchase_gift_amount - capital_amount))
    end
  end


  def create_saving(capital)
    saving = Saving.new(user_id: @current_user.id, capital_id: capital.id, savings_amount: get_saving_amount(capital))
    if saving.save
      update_saving_in_purchases(capital)
    end
  end

  def update_admin_amount(gift) 
    admin = AdminAccount.first
    admin_fee = gift.amount * ADMIN_FEE_PERCENT

    if admin
      admin.update(total_admin_amount: (admin.total_admin_amount + admin_fee))
    else
      admin = AdminAccount.new(ishami_bank_account_id: 2, total_admin_amount: admin_fee)
      admin.save
    end
  end

  def determine_bonus_amount(user_capitals = nil, user_invitees_capitals = nil)

    return if ((user_capitals && user_invitees_capitals) || (!user_capitals && !user_invitees_capitals))

    bonus_amount = 0
    case user_capitals ? user_capitals : user_invitees_capitals
    when 1..5
      bonus_amount = user_capitals ? BONUS_SHARE_HASH[:"5"] : BONUS_INVITATION_HASH[:"5"]
    when 6..49
      bonus_amount = user_capitals ? BONUS_SHARE_HASH[:"49"] : BONUS_INVITATION_HASH[:"49"]
    when 50..199
      bonus_amount = user_capitals ? BONUS_SHARE_HASH[:"199"] : BONUS_INVITATION_HASH[:"199"] 
    when 200..499
      bonus_amount = user_capitals ? BONUS_SHARE_HASH[:"499"] : BONUS_INVITATION_HASH[:"499"] 
    when 500..999
      bonus_amount = user_capitals ? BONUS_SHARE_HASH[:"999"] : BONUS_INVITATION_HASH[:"999"] 
    when 1000..1999
      bonus_amount = user_capitals ? BONUS_SHARE_HASH[:"1999"] : BONUS_INVITATION_HASH[:"1999"] 
    else
      bonus_amount = user_capitals ? BONUS_SHARE_HASH[:"2000"] : BONUS_INVITATION_HASH[:"2000"]
    end

    bonus_amount
  end
end