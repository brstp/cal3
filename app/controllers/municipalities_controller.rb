class MunicipalitiesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :authorized?, :except => [:show, :index]
  
  def index
    @municipalities = Municipality.all
  end
  
  def show
    @municipality = Municipality.find(params[:id])
    @municipality.update_attribute(:last_googleboted, Time.now) if request.headers["user_agent"].include? "Googlebot"
    @events = @municipality.upcoming_events #.paginate :page => params[:page], :per_page => 30
    @organizers = @municipality.events.count(:group => "organizer").sort_by { |k,v| -v}
    @markers = @municipality.events.to_gmaps4rails do |event, marker|
      marker.infowindow "<div class=\"info_window\"> <h1>#{event.subject}</h1> <p>Kategori: #{event.category.name.capitalize} </p><p>#{event.short_duration.capitalize} </p></div>"
      marker.picture map_marker(event)
      marker.title   "#{event.subject} \n(#{event.category.name.capitalize}) \n#{event.short_duration.capitalize}"
      #marker.sidebar "i'm the sidebar"
      marker.json({ :id => event.id, :foo => "bar" })
    end   
    #ActionController::Redirecting.
    
      respond_to do |format|
        format.html # show.html.erb
        format.ihtml
        format.rss  {
          redirect_to events_path(:format => :rss, :only_path => false, :municipality_id => @municipality.id, :mute_municipality => 1, :ver => 3), :status => :moved_permanently
          return
        }
        format.ics
      end
  end
  
  def new
    @municipality = Municipality.new
  end
  
  def create
    @municipality = Municipality.new(params[:municipality])
    if @municipality.save
      flash[:notice] = t 'flash.actions.create.notice'
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
      flash[:notice] = t('flash.actions.update.notice')
      redirect_to @municipality
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @municipality = Municipality.find(params[:id])
    @municipality.destroy
    flash[:notice] = t 'flash.actions.destroy.notice'
    redirect_to municipalities_url
  end


protected

  def authorized?
    if !current_user
      flash[:alert] = t 'flash.actions.not_authenticated'
      redirect_to :back
    else
      if !current_user.is_admin
        flash[:alert] = t 'flash.actions.not_admin'
        redirect_to :back  
      else
        # Do stuff...
      end
    end
  end
  
end
