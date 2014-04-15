class Cto < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :contacts, presence: true
  validates :schedule, presence: true
end
