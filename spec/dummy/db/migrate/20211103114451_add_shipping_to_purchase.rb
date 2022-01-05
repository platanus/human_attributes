class AddShippingToPurchase < ActiveRecord::Migration[6.1]
  def change
    add_column :purchases, :shipping, :integer
  end
end
