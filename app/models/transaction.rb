class Transaction < ApplicationRecord
  monetize :amount_cents, with_currency: :brl

  validates :amount_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
