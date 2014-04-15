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
    @ctos = Cto.all
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
