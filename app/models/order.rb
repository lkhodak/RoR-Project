class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :service
  # TODO Let's add enumeration column to avoid bad data
  enum status ['new','approved']

  #Let's add callback to update associated schedules before saving a date
  before_save {|record|
    # We approved the record and no confirmation was done previously. Let's update the associated Cto schedule
    if !record.new_record? && record.status=='approved' && record.confirmationDate?
      puts "Run prepappruval process"
      #Let's store current date
      record.confirmationDate = DateTime.current
      #TODO: We need to update cto schedule based on this data.Add the update for schedule
    end
  }
end
