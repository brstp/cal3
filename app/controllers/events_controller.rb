class EventsController < ApplicationController

before_filter :authenticate_user!, :except => [:show, :index]
before_filter :authorized?, :except => [:show, :index]
before_filter :authorized_for_this_event?, :except => [:show, :index, :new, :create]

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
      flash[:notice] = t 'flash.actions.update.notice'
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
  
  protected
  
  def authorized?
    unless current_user
      flash[:alert] = t 'flash.actions.not_authenticated'
      redirect_to :action => :back      
    else
      if !current_user.organizers and !current_user.is_admin?
        flash[:alert] = t 'flash.actions.not_member'
        redirect_to :back
      end
    end
  end
  
  def authorized_for_this_event? 
    @event = Event.find(params[:id])
    if (!current_user.organizers.include? @event.organizer and !current_user.is_admin?)
      flash[:alert] = t 'flash.actions.not_member_here'
        redirect_to :back
    end
  end
  
end
