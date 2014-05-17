class CtosController < ApplicationController
  def new
  end

  #Create new CTO based on form parameters 1
  def create
    @cto=Cto.new(cto_params)
    @cto.save
    redirect_to ctos_path
  end

  
   #Show CTO find by id param
  def show
    @cto = Cto.find(params[:id])
  end


  #Show all available CTO
  def index
    @ctos = Cto.all.page params[:page]
    @carBrends=getModelList
    @carServices=getServicesList
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

  #TODO should be refactored to got the data from dfb or international file
  def getModelList
    @ModelArray= Array.new
    @ModelArray.append("Audi")
    @ModelArray.append("BMW")
    @ModelArray.append("Shevrolet")
    @ModelArray.append("Toyota")
    @ModelArray.append("Nissan")
    @ModelArray.append("Honda")
    #generate mockup model
    return  @ModelArray
  end

  def getServicesList
    @ServicesArray= Array.new
    @ServicesArray.append("Fix engine")
    @ServicesArray.append("Change wheels")
    @ServicesArray.append("Fix electricity")
    @ServicesArray.append("change color")
    @ServicesArray.append("Wash car")
      #generate mockup model
    return  @ServicesArray
  end

end
