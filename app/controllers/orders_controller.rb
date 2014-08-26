class OrdersController < ApplicationController

  #Method to create new form
  def new
    @cto=Cto.find(params[:cto_id])

    # we need to get all services to evaluate and add them to the dropdown
    @services =@cto.services;

    #need to add info about checking the calendar and providing acceptable date range to fill
    @schedules=Schedule.where('schedules.date=? AND cto_id=?',Date.current ,params[:cto_id])

    #Need to calcualte. We need to make a reverse about schedule making a suggestion according to current time on server.
    @events = []
    @schedules.each do |schedule|
      @events.push(Event.new(schedule.date, schedule.start, schedule.end))
    end
    @order = Order.new
  end

  def create
    # TODO let's add logic to create an order with appropriate params.Save order and redirect to main cto page
    @cto=Cto.find (params[:cto_id])
    @service = Service.find(params[:selectedService])

    @order = Order.new

    #set order model parameters.Objects are stored as hashes.We don't need to have cae number
    #@order.carNumber=params[:order][:carNumber]
    @order.plannedDate=params[:order][:plannedDate]
    @order.status='New'
    @order.requestDate=Date.current
    @order.user=current_user

   # TODO: Admin should update the page and order changes should be reflected in base schedules according to new orders. Or special service should be executed during approval

    @order.uniqueCode=SecureRandom.hex(10)
    @order.save
    redirect_to cto_path (@cto)
  end

  def update
    #TODO: Add update functionality
  end

  def index
  #Get orders for particular cto based on input parameter.We will show them based on the status
  @orders= Order.joins(service: :cto).where('ctos.id' => params[:cto_id])
  end

end

class Event
  attr_accessor :date, :start, :end
  def initialize(date, startTime, endTime)
    @date=date
    @start=startTime
    @end=endTime
  end
end


