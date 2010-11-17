class OrganizersController < ApplicationController
  def index
    @organizers = Organizer.all
  end
  
  def show
    @organizer = Organizer.find(params[:id])
  end
  
  def new
    @organizer = Organizer.new
  end
  
  def create
    @organizer = Organizer.new(params[:organizer])
    if @organizer.save
      flash[:notice] = "Successfully created organizer."
      redirect_to @organizer
    else
      render :action => 'new'
    end
  end
  
  def edit
    @organizer = Organizer.find(params[:id])
  end
  
  def update
    @organizer = Organizer.find(params[:id])
    if @organizer.update_attributes(params[:organizer])
      flash[:notice] = "Successfully updated organizer."
      redirect_to @organizer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @organizer = Organizer.find(params[:id])
    @organizer.destroy
    flash[:notice] = "Successfully destroyed organizer."
    redirect_to organizers_url
  end
end
