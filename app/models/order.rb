class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :service


  #Let's add callback to update associated schedules before saving a date
  before_save {|record|
    # If record was approved than we have to update schedules
    if !record.new_record? && record.status=='approved' && record.confirmationDate?

      #Let's store current date
      record.confirmationDate = DateTime.current

      #Got a _service to retrive cto_id
      _service = Service.find(record.service_id)

      #Insert new schedule load based on order data
      _schedule = Schedule.new
      _schedule.date=Date.current
      _schedule.start=record.plannedDate
      #Schedule by default - 1 hour 60*60
      _schedule.end=_schedule.start + 60*60
      _schedule.cto_id = _service.cto_id
      _schedule.save
    end

   # we need to remove busy schedule from cancelled record
   if record.status=='cancelled'
     Schedule.where(:date => record.plannedDate).destroy_all;
   end


  }

end
