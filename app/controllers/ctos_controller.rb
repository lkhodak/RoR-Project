class CtosController < ApplicationController
  def new
  end

  #Create new CTO based on form parameters 1
  def create
    redirect_to ctos_path :requestDate=>params[:requestDate],:requestTime=>params[:requestTime], :page=>params[:page]
  end

  
   #Show CTO find by id param
  def show
    @cto = Cto.find(params[:id])
  end

   #Show all available CTO
  def index
         #Let's suggest that we cto has one service type
    if params[:requestDate].to_s.empty? || params[:requestTime].to_s.empty?
      @ctos = Cto.all.page params[:page]

    else
      myDate=params[:requestDate].to_s+ ' ' + params[:requestTime].to_s+':00'
      scheduleRequestDate = DateTime.strptime(myDate, '%d-%m-%Y %H:%M:%S')
      @ctos = Cto.joins(:schedules).where("start>=? OR end>=?", scheduleRequestDate, scheduleRequestDate).page params[:page]
    end
  end

  #Load object to put CTO data to edit
  def edit
    @cto = Cto.find(params[:id])
  end

  #Update edited data
  def update
    @cto = Cto.find(params[:id])
    if @cto.update(cto_params)
      redirect_to ctos_path
    else
      render 'edit'
    end
  end

  #Remove CTO from the database
  def destroy
    @cto = Cto.find(params[:id])
    @cto.destroy

    redirect_to ctos_path
  end


  #It's a special method to hack strong parameters
  private
  def cto_params
    params.require(:cto).permit(:name, :description, :address, :contacts,:schedule)
  end
end
