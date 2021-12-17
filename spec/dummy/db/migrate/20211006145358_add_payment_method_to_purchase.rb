class AddPaymentMethodToPurchase < ActiveRecord::Migration[6.1]
  def change
    add_column :purchases, :payment_method, :integer
  end
end
