# encoding: UTF-8

class EventsController < ApplicationController
include ActiveRecord::CounterCache

before_filter :authenticate_user!, :except => [:show, :index]
before_filter :authorized?, :except => [:new, :show, :index]
before_filter :authorized_for_this?, :except => [:show, :index, :new, :create]
  

  def index
      today = Time.zone.now.beginning_of_day
      this_month = Time.zone.now.beginning_of_month
      this_week = Time.zone.now.beginning_of_week
      this_year = Time.zone.now.beginning_of_year
      beginning_of_time = Time.parse('1970-03-27')
      christmas_eve = Time.zone.now.beginning_of_year + 11.month + 23.day
      new_years_eve = Time.zone.now.beginning_of_year + 11.month + 30.day
      
      facet_from = Timeliness.parse(params[:from])
      facet_to = Timeliness.parse(params[:to])

      if facet_from.blank? && facet_to.blank? && params[:stop] != "past" && params[:stop] != "future"
        facet_from = Time.zone.now.beginning_of_day
      end
      

      result = Event.search do
        order_by(:start_datetime, :asc)
        keywords params[:q]
        paginate :page => params[:page]
        
        facet :stop do
          row "today" do
            with :stop, today..(today + 1.day)
          end
          row "tomorrow" do
            with :stop, (today + 1.day)..(today + 2.day)
          end
          row "this_week" do
            with :stop, this_week..(this_week + 1.week)
          end
          row "this_weekend" do
            with :stop, (this_week + 5.day)..(this_week + 7.day)
          end
          row "next_week" do
            with :stop, (this_week + 1.week)..(this_week + 2.week)
          end
          row "next_weekend" do
            with :stop, (this_week + 12.day )..(this_week + 14.day)
          end
          row "christmas_eve" do
            with :stop, christmas_eve..(christmas_eve + 1.day)
          end
          row "christmas_day" do
            with :stop, (christmas_eve + 1.day)..(christmas_eve + 2.day)
          end
          row "new_years_eve" do
            with :stop, new_years_eve..(new_years_eve + 1.day)
          end
          row "walpurgis_night" do
            with :stop, (this_year+ 4.month + 29.day)..(this_year + 4.month + 30.day)
          end
        end

        facet :c1_id, :limit => params[:cl].to_i + 6
        facet :c2_id
        facet :c3_id

        facet :organizer_id
        facet :municipality_id, :limit => params[:ml].to_i + 6
        facet :syndicated_by_organizer_ids

        # TODO Sök nära mig. # s.near([40,5, -72.3], :distance => 5, :sort => true)


        unless params[:stop].blank?
          case
            when params[:stop] == "this_week"
              with(:stop).between((this_week)..(this_week+1.week))
            when params[:stop] == "next_week"
              with(:stop).between((this_week+1.week)..(this_week+2.week))
            when params[:stop] == "today"
              with(:stop).between(today..(today + 1.day))
            when params[:stop] == "tomorrow"
              with(:stop).between((today + 1.day)..(today + 2.day))
            when params[:stop] == "this_weekend"
              with(:stop).between((this_week + 5.day)..(this_week + 7.day))
            when params[:stop] == "next_weekend"
              with(:stop).between((this_week + 12.day )..(this_week + 14.day))
            when params[:stop] == "this_month"
              with(:stop).between((this_month)..(this_month + 1.month))
            when params[:stop] == "next_month"
              with(:stop).between((this_month + 1.month)..(this_month + 2.month))
            when params[:stop] == "future"
              with(:stop).between(today..(today + 10.year))
            when params[:stop] == "past"
              with(:stop).between((today - 100.year)..today)
            when params[:stop] == "christmas_eve"
              with(:stop).between(christmas_eve..(christmas_eve + 1.day))
            when params[:stop] == "christmas_day"
              with(:stop).between((christmas_eve + 1.day)..(christmas_eve + 2.day))
            when params[:stop] == "new_years_eve"
              with(:stop).between(new_years_eve..(new_years_eve + 1.day))
            when params[:stop] == "walpurgis_night"
              with(:stop).between((this_year + 4.month + 29.day)..(this_year + 4.month + 30.day ))
          end
        end


      with(:stop).greater_than(facet_from) unless facet_from.blank?
      with(:stop).less_than(facet_to + 1.day) unless facet_to.blank?      
      with(:c1_id).equal_to( params[:c1_id].to_i ) unless params[:c1_id].blank?
      with(:c2_id).equal_to( params[:c2_id].to_i ) unless params[:c2_id].blank?
      with(:c3_id).equal_to( params[:c3_id].to_i ) unless params[:c3_id].blank?
      with( :category_facet_id ).equal_to( params[:category_facet_id].to_i ) unless params[:category_facet_id].blank? # for compability reasons with rss version < 3
      with(:organizer_id).equal_to( params[:organizer_id].to_i ) unless params[:organizer_id].blank?
      with(:municipality_id).equal_to( params[:municipality_id].to_i ) unless params[:municipality_id].blank?
      with(:syndicated_by_organizer_ids).equal_to(params[:sbo_id].to_i) unless params[:sbo_id].blank?
    end
    
    
    @from_date = facet_from
    @to_date = facet_to

    @stop_facet_rows = result.facet(:stop).rows if result.facet( :stop )
    @c1_facet_rows = result.facet(:c1_id).rows if result.facet( :c1_id )
    @c2_facet_rows = result.facet(:c2_id).rows if result.facet( :c2_id )
    @c3_facet_rows = result.facet(:c3_id).rows if result.facet( :c3_id )
    @organizer_facet_rows = result.facet(:organizer_id).rows if result.facet( :organizer_id )
    @municipality_facet_rows = result.facet(:municipality_id).rows if result.facet( :municipality_id )
    @syndicated_by_organizer_facet_rows = result.facet(:syndicated_by_organizer_ids).rows if result.facet(:syndicated_by_organizer_ids)

    @events = result
    @hit_numbers = result.total

     
    event_set = []
    for event in @events #TODO refactor two loops into one
      event_set << event
    end


    @markers = event_set.to_gmaps4rails do |event, marker|
      marker.infowindow "<div class=\"info_window\"> <h1>#{view_context.link_to(event.subject, event)}</h1> <p>Kategori: #{event.category.name.capitalize} </p><p>#{event.short_duration.capitalize} </p></div>"
      marker.picture map_marker(event)
      marker.title   "#{event.subject} \n(#{event.category.name.capitalize}) \n#{event.short_duration.capitalize}"
      #marker.sidebar "i'm the sidebar"
      marker.json({ :id => event.id, :foo => "bar" })
    end    
    
    @gallery =  Event.where(['stop_datetime >= ? AND image1_file_size > 0', "#{Time.now}"]).order('created_at DESC').limit(9)

    if @gallery.count < 9
          @gallery = @gallery +  Event.where(['stop_datetime < ? AND image1_file_size > 0', "#{Time.now}"]).order('created_at DESC').limit(9-@gallery.count)
    end

    @gallery.shuffle!
    
    respond_to do |format|
      format.html
      format.rss {
        unless params[:ver].present?
          redirect_to params.merge( :ver => 3 )
          return
        end
        }
    end

  end


  def show
    @event = Event.find(params[:id])
    @mail_message = MailMessage.new
    @mail_message.subject = "Om evenemanget: #{@event.subject} – #{l @event.start_datetime, :format => :shorty}"
    @mail_message.ip = request.remote_ip 
    @mail_message.referer = request.headers["referer"]
    @mail_message.user_agent = request.headers["user_agent"]
    @mail_message.current_page = params[:current_page]
    @mail_message.event_id = @event.id
    unless @event.human_name.blank? 
      @mail_message.to_name = @event.human_name
    else
      @mail_message.to_name = @event.email
    end
    @mail_message.current_page =  "#{request.protocol}#{request.host_with_port}#{request.fullpath}" if @mail_message.current_page.blank?
    if current_user
      @mail_message.from_email = current_user.try :email
      @mail_message.from_first_name = current_user.try :first_name
      @mail_message.from_last_name = current_user.try :last_name
    end
    
    @markers = @event.to_gmaps4rails do |event, marker|
      marker.infowindow "<div class=\"info_window\"> <h1>#{view_context.link_to(event.subject, event)}</h1> <p>Kategori: #{event.category.name.capitalize} </p><p>#{event.short_duration.capitalize} </p></div>"
      marker.picture map_marker(event)
      marker.title   "#{event.subject} \n(#{event.category.name.capitalize}) \n#{event.short_duration.capitalize}"
      #marker.sidebar "i'm the sidebar"
    end    
    
    
    Event.increment_counter :counter, @event.id
    @event.update_attribute(:last_googleboted, Time.now) if request.headers["user_agent"].include? "Googlebot"
    @event.human_name = @event.email if @event.human_name.blank?
    respond_to do |format|
      format.html
      format.ihtml
      format.ics
    end
  end


  
  



  def new
    @organizers = current_user.organizers
    @event = Event.new
    @event.email = current_user.email

    # TODO Scope to only organizers I have permissions to.
    @event.organizer_id = params[:organizer_id] unless params[:organizer_id].blank? 
    
    @markers = @event.to_gmaps4rails 

    if @event.human_name.blank?
      @event.human_name = " "
      unless (current_user.first_name.blank?)
        @event.human_name = current_user.first_name + " "
      end
      unless (current_user.last_name.blank?)
        @event.human_name += current_user.last_name
      end
    end
    @event.human_name.strip!
  end

  def create
    @organizers = current_user.organizers
    event_parameters = params[:event]
    organizer_id = event_parameters[:organizer_id]
    event_parameters.delete :organizer_id
    @event = Event.new(event_parameters) 
    @event.created_by_user_id = current_user.id
    @event.organizer_id = organizer_id # TODO Scope to only organizers I have permissions to.
    @markers = @event.to_gmaps4rails 
    if @event.save
      OrganizerMailer.delay.new_event_confirmation(@event, current_user)
      flash[:notice] = t 'events.flash.notice.created'
      redirect_to @event
    else
      render :action => 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
    @markers = @event.to_gmaps4rails 
  end

  def update
    @event = Event.find(params[:id])        # TODO Scope to only organizers I have permissions to.
    @event.updated_by_user_id = current_user.id    
    @markers = @event.to_gmaps4rails 
    params[:event].delete :organizer_id unless current_user.is_admin?
    if @event.update_attributes(params[:event])
      OrganizerMailer.delay.changed_event_confirmation(@event, current_user)
      flash[:notice] = t 'events.flash.notice.updated'
      redirect_to @event
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id]) # TODO Scope to only organizers I have permissions to.
    @event.destroy
    # TODO: Mejla om raderad
    flash[:notice] = t 'flash.actions.destroy.notice'
    redirect_to events_url
  end



  protected


  def authorized?
    unless current_user
      flash[:alert] = t 'flash.actions.not_authenticated'
      redirect_to :action => :back
    else
      if current_user.organizers.blank? and !current_user.is_admin?
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
