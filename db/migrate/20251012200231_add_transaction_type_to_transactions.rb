class AddTransactionTypeToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_reference :transactions, :transaction_type, foreign_key: true
  end
end
