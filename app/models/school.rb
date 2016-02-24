class School < ActiveRecord::Base
  has_many :users, inverse_of: :school

  def posts
  	User.where(:school_id=>self.id).includes(:posts).map{|u| u.posts}.flatten! rescue []
  end
end
