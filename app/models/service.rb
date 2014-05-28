class Service < ActiveRecord::Base
  belongs_to :cto
  has_many :orders
  has_many :reviews
end
