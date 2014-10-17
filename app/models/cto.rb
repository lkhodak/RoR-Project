class Cto < ActiveRecord::Base
  has_many :services
  has_many :schedules
  max_paginates_per 9
  # validates :name, presence: true
  # validates :description, presence: true
  # validates :address, presence: true
  # validates :contacts, presence: true
  # validates :schedule, presence: true
  geocoded_by :address
  after_validation :geocode
end
