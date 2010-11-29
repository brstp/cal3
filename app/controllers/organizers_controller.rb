class OrganizersController < ApplicationController

before_filter :authenticate_user!, :except => [:show, :index]

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
      flash[:notice] = t 'flash.actions.create.notice'
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
      flash[:notice] = t 'flash.actions.update.notice'
      redirect_to @organizer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @organizer = Organizer.find(params[:id])
    @organizer.destroy
    flash[:notice] = t 'flash.actions.destroy.notice'
    redirect_to organizers_url
  end
end
