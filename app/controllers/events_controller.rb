class EventsController < ApplicationController

before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @events = Event.all(:order => 'start_datetime ASC')
    respond_to do |format|
      format.html
      format.rss
    end
  end
  
  def show
    @event = Event.find(params[:id])
  end
  
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:notice] = t 'flash.actions.create.notice'
      redirect_to @event
    else
      render :action => 'new'
    end
  end
  
  def edit
    @event = Event.find(params[:id])
  end
  
  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = t('flash.actions.update.notice')
      redirect_to @event
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:notice] = t 'flash.actions.destroy.notice'
    redirect_to events_url
  end
end
