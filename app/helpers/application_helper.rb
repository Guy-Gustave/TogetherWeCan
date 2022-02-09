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

  def determine_aurthorization_of_recreation(capital)
    maturity_time = capital.updated_at.to_s

    week_past = Date.parse(maturity_time).upto(Data.today).count.fdiv(7).floor

    return false if week_past != 1

    true
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


  def recreate_capitals 
    capitals = Capital.where(gift_payment: 3)
    
    i = 0
    while i < capitals.length
      allow_recreation = false;
      allow_recreation = determine_aurthorization_of_recreation(capital);

      if allow_recreation
        transaction = TransactionsController.new
        transaction.recreate_capital(capitals[i])
      end
      i += 1
    end
  end
end
