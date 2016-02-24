class UsersController < ApplicationController
	layout 'user'
  before_action :authenticate_user!

  def info
  end
  
  def show
  	@favorites = current_user.favorites.includes(:favoritable)
  end

  def history
  end
end
