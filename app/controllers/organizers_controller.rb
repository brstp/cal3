# encoding: UTF-8

class OrganizersController < ApplicationController


before_filter :authenticate_user!, :except => [:show, :index]
before_filter :authorized?, :except => [:show, :index, :new, :create]
before_filter :authorized_for_this?, :except => [:show, :index, :new, :create]

  def index
    @organizers = Organizer.all(:order => 'name ASC')
  end

  def show
    @organizer = Organizer.find(params[:id])
    @events = @organizer.upcoming_events #.paginate :page => params[:page], :per_page => 10
    
    @markers = @organizer.events.to_gmaps4rails do |event, marker|
      marker.infowindow "<div class=\"info_window\"> <h1>#{event.subject}</h1> <p>Kategori: #{event.category.name.capitalize} </p><p>#{event.short_duration.capitalize} </p></div>"
      marker.picture map_marker(event)
      marker.title   "#{event.subject} \n(#{event.category.name.capitalize}) \n#{event.short_duration.capitalize}"
      #marker.sidebar "i'm the sidebar"
      marker.json({ :id => event.id, :foo => "bar" })
    end   
    
    @organizer.update_attribute(:last_googleboted, Time.now) if request.headers["user_agent"].include? "Googlebot"
    @membership = Membership.new
    respond_to do |format|
      format.html # show.html.erb
      format.ihtml
      format.rss
      format.ics
    end
  end


  def new
    @organizer = Organizer.new
    @organizer.email = current_user.email
  end
 

  def create
    @organizer = Organizer.new(params[:organizer])
    @organizer.created_by_user_id = current_user.id

    if @organizer.save
      flash[:notice] = t 'organizer.flash.notice.created'

      @membership = @organizer.memberships.build(:user_id => current_user.id )
      if @membership.save
        flash[:notice] = I18n.t 'flash.actions.create.organizer_and_membership'
      else
        flash[:alert] = I18n.t 'flash.actions.create.couldnt_save_membership'
      end
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
    @organizer.updated_by_user_id = current_user.id
    if @organizer.update_attributes(params[:organizer])
      flash[:notice] = t 'organizer.flash.notice.updated'
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
    @organizer = Organizer.find(params[:id])
    if !current_user.organizers.include? @organizer and !current_user.is_admin?
      flash[:alert] = t 'flash.actions.not_member_here'
        redirect_to :back
    end
  end
end
