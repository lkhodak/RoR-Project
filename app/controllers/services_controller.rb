class ServicesController < ApplicationController

  def create
    @cto = Cto.find(params[:cto_id])
    @service = @cto.services.create(service_params)
    redirect_to cto_path(@cto)
  end

  private
  def service_params
    params.require(:service).permit(:description, :price)
  end



end
