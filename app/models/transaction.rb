class Transaction < ApplicationRecord
  monetize :amount_cents, with_currency: :brl

  validates :amount_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true

  belongs_to :transaction_type, optional: true
  belongs_to :payment_type, optional: true
  has_many :installments, dependent: :destroy, inverse_of: :parent_transaction

  def total_portions
    installments.first&.total_portions || 1
  end

  def update_installments(new_total)
    return if new_total.to_i <= 1 && !installments.exists?

    new_total = new_total.to_i
    current_total = total_portions

    if new_total > current_total
      # Adiciona novas parcelas
      (current_total..new_total).each do |portion|
        installments.create!(portion: portion, total_portions: new_total)
      end
      # Atualiza total nas parcelas existentes
      installments.update_all(total_portions: new_total)
    elsif new_total < current_total
      # Remove parcelas excedentes
      installments.where("portion > ?", new_total).destroy_all
      # Atualiza total nas parcelas restantes
      installments.update_all(total_portions: new_total)
    end
  end
end
