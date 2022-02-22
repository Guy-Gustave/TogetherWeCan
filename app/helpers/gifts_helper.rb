module GiftsHelper
  include CapitalsHelper

  GIFT_AMOUNT = (CAPITAL_AMOUNT/5.5).round

  SAVING_AMOUNT = (CAPITAL_AMOUNT) / 2

  ADMIN_FEE_PERCENT = 0.03

  def get_gift_amount(capital)
    gift_amount = (capital.amount / 5.5).round
    gift_amount = (capital.amount / 4.05).round if capital.purchase.week_number >= 17

    gift_amount
  end

  def get_saving_amount(capital)
    return (capital.amount / 2)
  end
end