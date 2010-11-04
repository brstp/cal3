class MunicipalitiesController < ApplicationController
  def index
    @municipalities = Municipality.all
  end
  
  def show
    @municipality = Municipality.find(params[:id])
  end
  
  def new
    @municipality = Municipality.new
  end
  
  def create
    @municipality = Municipality.new(params[:municipality])
    if @municipality.save
      flash[:notice] = "Successfully created municipality."
      redirect_to @municipality
    else
      render :action => 'new'
    end
  end
  
  def edit
    @municipality = Municipality.find(params[:id])
  end
  
  def update
    @municipality = Municipality.find(params[:id])
    if @municipality.update_attributes(params[:municipality])
      flash[:notice] = "Successfully updated municipality."
      redirect_to @municipality
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @municipality = Municipality.find(params[:id])
    @municipality.destroy
    flash[:notice] = "Successfully destroyed municipality."
    redirect_to municipalities_url
  end
end
