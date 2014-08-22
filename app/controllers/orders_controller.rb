class OrdersController < ApplicationController

  #Method to create new form
  def new
    @cto=Cto.find(params[:cto_id])

    # we need to get all services to evaluate and add them to the dropdown
    @services =@cto.services;

    #need to add info about checking the calendar and providing acceptable date range to fill
    @schedules=Schedule.where('schedules.date=? AND cto_id=?',Date.current ,params[:cto_id])

    #Need to calcualte
    @events = []
    @schedules.each do |schedule|
      @events.push(Event.new(schedule.date, schedule.start, schedule.end))
    end
    @order = Order.new
  end

  def create
    # TODO let's add logic to create an order with appropriate params.Save order and redirect to main cto page
    @cto=Cto.find (params[:cto_id])
    @service = Service.find(params[:service_id])
    @order = Order.new

    #set order model parameters.Objects are stored as hashes.
    @order.carNumber=params[:order][:carNumber]
    @order.plannedDate=params[:order][:plannedDate]
    @order.status='New'
    @order.requestDate=Date.current
    @order.user=current_user

    #TODO: Implement separate page to show secure random info for the user.Thank you page.

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


