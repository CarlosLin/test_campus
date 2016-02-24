class ChangeColumnToPosts < ActiveRecord::Migration
  def up
    change_column :posts, :content, :text, :limit => nil
  end
  def down
    change_column :posts, :content, :string, :limit => 255
  end
end
