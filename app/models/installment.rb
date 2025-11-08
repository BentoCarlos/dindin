class Installment < ApplicationRecord
  belongs_to :parent_transaction, class_name: "Transaction", foreign_key: "transaction_id"

  validates :portion, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total_portions, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :portion_cannot_exceed_total

  private

  def portion_cannot_exceed_total
    if portion && total_portions && portion > total_portions
      errors.add(:portion, "não pode ser maior que o total de parcelas")
    end
  end
end
