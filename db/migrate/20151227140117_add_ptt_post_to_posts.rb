class AddPttPostToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :ptt_post_id, :string
  	add_column :posts, :ptt_post_link, :string
  end
end
