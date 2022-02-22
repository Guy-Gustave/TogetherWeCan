class IshamiBankAccount < ApplicationRecord
    has_one :ishami_account_balance
    has_one :admin_account
end
