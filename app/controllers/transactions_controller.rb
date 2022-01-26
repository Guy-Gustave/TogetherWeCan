class TransactionsController < ApplicationController

  include CurrentUserConcern

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

  end

  private

  def capital_params
    params.require(:transaction).permit(:shares_number)
  end
end