class TransactionsController < ApplicationController

  include CurrentUserConcern
  include GiftsHelper

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


        @transaction = Transaction.new(capital_id: transaction_capital.id, amount: transaction_capital.amount, transaction_type: "deposit", week_number: 0)

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

    @transaction = Transaction.new(capital_id: capital.id, amount: transaction_gift.amount, transaction_type: "payment", gift_id: transaction_gift.id, week_number: 0)
    @transaction.save
    
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

    i = 0
    while i < number_of_capitals
      new_capital = CapitalsController.new
      transaction_capital = new_capital.create(purchase);
  
      transaction = Transaction.new(capital_id: transaction_capital.id, amount: transaction_capital.amount, transaction_type: "deposit", week_number: 0)
  
      transaction.save

      i += 1
    end
  end

  def recreate_capital(capital)
    new_recreation_date = capital.updated_at.to_s
    new_recreation_date = (Date.parse(new_recreation_date) + 7).to_s

    capital_amount = CAPITAL_AMOUNT
    purchase = capital.purcahse

    capital_amount = CAPITAL_AMOUNT_2 if purchase.week_number >= 33

    capital.update(amount: capital_amount, period: 0, gift_counter: 0, recreation_date: new_recreation_date, capital_status: "recreated")

    render json: {
      capital_updated: capital
    }
  end

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

  def create_saving(capital)
    saving = Saving.new(user_id: @current_user.id, capital_id: capital.id, savings_amount: get_saving_amount(capital))
    if saving.save
      update_saving_in_purchases(capital)
    end
  end
end