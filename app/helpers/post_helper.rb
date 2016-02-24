module PostHelper
	 # ***************
	 #     首頁圖片
	 # ***************
  def index_cover_image(post)
    if post.avatar_file_name?
      link_to (image_tag post.avatar.url(:medium)), post,class: 'thumbnail'
    else
      link_to (image_tag post.cover_image), post, class: 'thumbnail'
    end
  end
  # ***************
	#  	 show_page
  # ***************
  def have_avatar_file
  	image_tag @post.avatar.url(:medium) if @post.avatar_file_name?
  end

  def have_favorites_id_or_not
  	if user_signed_in?
  		if @post.favorites.pluck(:user_id).include?(current_user.id)
  			favorite_id = @post.favorites.find_by(:user_id => current_user.id).id
  		end
  	end
  	return favorite_id
  end
end
