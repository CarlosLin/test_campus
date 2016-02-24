class Message < ActiveRecord::Base
  belongs_to :post, :inverse_of => :messages
  belongs_to :user
end
