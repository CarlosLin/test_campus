require 'uri'
class PostsController < ApplicationController
  layout 'post'
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :index_all, :show]
  def index
    @posts = Post.all
  end

  def index_all
    if params[:search]
      @posts = Post.search(params[:search], params[:page])
      p @posts.total_pages
    else
        @posts = Post.order('id DESC').paginate(:page => params[:page], :per_page => 13)
      # render :json => @posts
    end  
  end

  def show
    @post_favorite =  current_user.favorites.find_by(:favoritable_id => @post.id) if user_signed_in?
    @favorite_id = @post_favorite[:id] unless @post_favorite.nil?
    @post.punch(request)
    @messages = Message.where(post_id: @post).includes(:user)
    render :layout => 'show_post'
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    Post.sample_cover_img(@post) if !@post.avatar_file_name?
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    Post.sample_cover_img(@post) if !@post.avatar_file_name?
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  private
    def find_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:name, :content, :avatar)
    end
end