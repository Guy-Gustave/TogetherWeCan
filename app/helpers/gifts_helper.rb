module GiftsHelper
  include CapitalsHelper

  GIFT_AMOUNT = (CAPITAL_AMOUNT/5.5).round

  SAVING_AMOUNT = (CAPITAL_AMOUNT) / 2
end