class Admin::PostsController < AdminController
  layout 'admin'
  before_action :set_admin_post, only: [:show, :edit, :update, :destroy]

  # GET /admin/posts
  def index
    @admin_posts = Admin::Post.all
  end

  # GET /admin/posts/1
  def show
  # question
    @post = Post.find(params[:id])
    @messages = Message.where(post_id: @admin_post)
  end

  # GET /admin/posts/new
  def new
    @admin_post = Admin::Post.new
  end
  # POST /admin/posts
  def create
    @admin_post = Admin::Post.new(admin_post_params)
    if @admin_post.save
      redirect_to @admin_post
      flash[:notice] = 'Post was successfully created.'
    else
      render :new
    end
  end

  # GET /admin/posts/1/edit
  def edit
  end


  # PATCH/PUT /admin/posts/1
  def update
      if @admin_post.update(admin_post_params)
        redirect_to @admin_post
        flash[:notice] = 'Post was successfully updated.'
      else
        render :edit
      end
  end

  # DELETE /admin/posts/1
  def destroy
    @admin_post.destroy
    respond_to do |format|
      format.html { redirect_to admin_posts_url, notice: 'Post was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_post
      @admin_post = Admin::Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_post_params
      params.require(:admin_post).permit(:name, :content, :avatar)
    end
end
