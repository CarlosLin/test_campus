class AddTypeIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :type_id, :integer
  end
end
