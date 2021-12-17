class AddStoreToPurchase < ActiveRecord::Migration[6.1]
  def change
    add_column :purchases, :store, :integer
  end
end
