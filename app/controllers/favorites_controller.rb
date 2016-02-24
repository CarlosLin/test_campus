class FavoritesController < ApplicationController
  before_action :find_post
  before_action :authenticate_user!, only: [:create, :destroy]
  def create
    @favorite = current_user.favorites.build(favoritable: @post)
    @favorite.save
    render json: @favorite
  end
  def destroy
    @favorite = current_user.favorites.find_by favoritable_id: @post
    @favorite.destroy
    redirect_to @post
  end

  private
    def find_post
      @post = Post.find(params[:post_id])
    end
end