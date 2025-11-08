class CreateInstallments < ActiveRecord::Migration[8.0]
  def change
    create_table :installments do |t|
      t.references :transaction, null: false, foreign_key: true
      t.integer :portion, null: false
      t.integer :total_portions, null: false
      t.date :payment_date, null: false, default: -> { 'CURRENT_DATE' }
      t.timestamps
    end
  end
end
