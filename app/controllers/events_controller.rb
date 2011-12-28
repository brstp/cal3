# encoding: UTF-8

class EventsController < ApplicationController
include ActiveRecord::CounterCache

before_filter :authenticate_user!, :except => [:show, :index]
before_filter :authorized?, :except => [:new, :show, :index]
before_filter :authorized_for_this?, :except => [:show, :index, :new, :create]
  

  def index
      #TODO Add almanac function to look up all absolute and relative days.
      # summer_holiday:
      # christmas_holiday:
      # midsummer:
      # sport_holiday1:
      # sport_holiday2:
      # sport_holiday3:
      # easter_holiday1:
      # easter_holiday2:
      #TODO Config setting for number of hits per page

      today = Time.zone.now.beginning_of_day
      this_month = Time.zone.now.beginning_of_month
      this_week = Time.zone.now.beginning_of_week
      this_year = Time.zone.now.beginning_of_year
      beginning_of_time = Time.parse('1970-03-27')
      christmas_eve = Time.zone.now.beginning_of_year + 11.month + 23.day
      new_years_eve = Time.zone.now.beginning_of_year + 11.month + 30.day

      result = Event.search do
        keywords params[:q]
        paginate :per_page => 30, :page => params[:page]
        facet :category_facet_id, :organizer_id, :municipality_id
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
          row "this_month" do
            with :stop, (this_month)..(this_month + 1.month)
          end
          row "next_month" do
            with :stop, (this_month + 1.month)..(this_month + 2.month)
          end
          row "future" do
            with :stop, today..(today + 10.year)
          end
          row "past" do
            with :stop, (today - 100.year)..today
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

        order_by(:start_datetime, :asc)
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

      unless params[:stop] == "past"
        with(:stop).between(today..(today + 10.year))
      else
        with(:stop).between((today - 100.year)..today)
      end

      unless params[:category_facet_id].blank?
        with( :category_facet_id ).equal_to( params[:category_facet_id].to_i )
      end

      unless params[:organizer_id].blank?
        with( :organizer_id ).equal_to( params[:organizer_id].to_i )
      end

      unless params[:municipality_id].blank?
        with( :municipality_id ).equal_to( params[:municipality_id].to_i )
      end

    end

    if result.facet( :stop )
      @stop_facet_rows = result.facet(:stop).rows
    end

    if result.facet( :category_facet_id )
      @category_facet_rows = result.facet(:category_facet_id).rows
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
    @event = Event.find(params[:id])
    Event.increment_counter :counter, @event.id
    @event.update_attribute(:last_googleboted, Time.now) if request.headers["user_agent"].include? "Googlebot"
    respond_to do |format|
      format.html
      format.ics
    end
  end


  def new
    @organizers = current_user.organizers
    @event = Event.new
    @event.email = current_user.email
    @event.human_name = ''
    @event.organizer_id = params[:organizer_id]
    unless (current_user.first_name.blank?)
      @event.human_name += current_user.first_name + " "
    end
    unless (current_user.last_name.blank?)
      @event.human_name += current_user.last_name
    end
    @event.human_name.strip!
  end

  def create
    @organizers = current_user.organizers
    @event = Event.new(params[:event])
    @event.created_by_user_id = current_user.id
    if @event.save
      OrganizerMailer.new_event_confirmation(@event, current_user).deliver
      flash[:notice] = t 'events.flash.notice.created'
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
    @event.updated_by_user_id = current_user.id
    if @event.update_attributes(params[:event])
      OrganizerMailer.changed_event_confirmation(@event, current_user).deliver
      flash[:notice] = t 'events.flash.notice.updated'
      redirect_to @event
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
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
