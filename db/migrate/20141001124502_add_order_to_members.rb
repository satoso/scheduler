class AddOrderToMembers < ActiveRecord::Migration
  def change
    add_column :members, :order, :integer
  end
end
