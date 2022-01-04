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
    # create a capital
    # use it to create a transaction;
    new_capital = CapitalsController.new
    transaction_capital = new_capital.create(@current_user);


    @transaction = Transaction.new(capital_id: transaction_capital.id, amount: transaction_capital.amount, transaction_type: "deposit", week_number: 0)

    @transaction.save


    render json: {
      transaction: @transaction
    }
  end
end