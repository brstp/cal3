class EventsController < ApplicationController
include ActiveRecord::CounterCache

before_filter :authenticate_user!, :except => [:show, :index]
before_filter :authorized?, :except => [:show, :index]
before_filter :authorized_for_this?, :except => [:show, :index, :new, :create]
 
 
  def index

    result = Event.solr_search do |s|
      
      s.keywords params[:q]
      s.facet :category_id, :organizer_id, :municipality_id
      s.order_by(:start_datetime, :asc)

      
      unless params[:category_id].blank?
        s.with( :category_id ).equal_to( params[:category_id].to_i )
      # else
        # s.facet :category_id
      end
      
      unless params[:organizer_id].blank?
        s.with( :organizer_id ).equal_to( params[:organizer_id].to_i )
      # else
        # s.facet :organizer_id
      end

      unless params[:municipality_id].blank?
        s.with( :municipality_id ).equal_to( params[:municipality_id].to_i )
      # else
        # s.facet :municipality_id
      end
      
    end
    
    if result.facet( :category_id )
      @category_facet_rows = result.facet(:category_id).rows
    end
    
    if result.facet( :organizer_id )
      @organizer_facet_rows = result.facet(:organizer_id).rows
    end    
    
    if result.facet( :municipality_id )
      @municipality_facet_rows = result.facet(:municipality_id).rows
    end

    
    @events = result
    
    respond_to do |format|
      format.html
      format.rss
    end
  
  end
  
  
  def show
    Event.increment_counter :counter, params[:id]
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html
      format.ics
    end
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
