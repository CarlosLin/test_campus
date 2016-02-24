class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  def create
    @post = Post.find(params[:post_id])
    @message = Message.create(params[:message].permit(:msg))
    @message.user_id = current_user.id
    @message.post_id = @post.id

    if @message.save
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end
end
