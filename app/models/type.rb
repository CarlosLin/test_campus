class Type < ActiveRecord::Base
  has_many :posts, :inverse_of => :type
  
end
