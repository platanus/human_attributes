class CreatePurchases < ActiveRecord::Migration[4.2]
  def change
    create_table :purchases do |t|
      t.boolean :paid
      t.decimal :commission
      t.integer :quantity
      t.string :state
      t.datetime :expired_at
      t.decimal :amount
      t.text :description

      t.timestamps null: false
    end
  end
end
