module ApplicationHelper

  def determine_authorization_of_payment(capital)
    current_period = capital.period
    capital_creation_date = capital.created_at.to_s
    target_period  = 3

    target_period = 1 if current_period == 0

    # total_weeks_covered = Date.parse(capital_creation_date).upto(Date.today).count.fdiv(7).floor

    total_weeks_covered = Date.parse(capital_creation_date).upto(Date.today).count.floor

    weeks_difference = total_weeks_covered - current_period

    return true if weeks_difference == target_period

    false
  end


  def make_payments
    capitals = Capital.all

    i = 0
    while i < capitals.length
      allow_payment = false;
      allow_payment = determine_authorization_of_payment(capitals[i])

      if allow_payment
        transaction = TransactionsController.new
        transaction.create_gift_payment(capitals[i]);
      end

      i += 1
    end

  end
end
