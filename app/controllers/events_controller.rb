class EventsController < ApplicationController

before_filter :authenticate_user!, :except => [:show, :index]
before_filter :authorized?, :except => [:show, :index]
before_filter :authorized_for_this?, :except => [:show, :index, :new, :create]
 
 
  def index
    @events = if params[:q].blank? 
      Event.where("stop_datetime >= ? AND start_datetime <= ?", 
                Time.now.beginning_of_day, Time.now.end_of_day + 22.months ).
                order('start_datetime ASC').limit 200
    else
      result = Event.solr_search do |s|
        s.keywords params[:q]
        unless params[:category_id].blank?
          s.with( :category_id ).equal_to( params[:category_id].to_i )
        else
          s.facet :category_id
        end
      end
      if result.facet( :category_id )
        @facet_rows = result.facet(:category_id).rows
      end
      result
    end
    
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
    @event.email = current_user.email
    @event.email_name = ''
    unless (current_user.first_name.blank?) 
      @event.email_name += current_user.first_name + " " 
    end
    unless (current_user.last_name.blank?) 
      @event.email_name += current_user.last_name 
    end
    @event.email_name.strip!
    @event.phone_name = @event.email_name
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
      if current_user.organizers.empty? and !current_user.is_admin?
        flash[:alert] = t 'flash.actions.not_member'
        redirect_to :back
      end
    end
  end
  
  def authorized_for_this? 
    @event = Event.find(params[:id])
    if (!current_user.organizers.include? @event.organizer and !current_user.is_admin?)
      flash[:alert] = t 'flash.actions.not_member_here'
        redirect_to :back
    end
  end
  
end
