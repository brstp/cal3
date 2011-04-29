# encoding: UTF-8

class EventsController < ApplicationController
include ActiveRecord::CounterCache

before_filter :authenticate_user!, :except => [:show, :index]
before_filter :authorized?, :except => [:show, :index]
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
        facet :start do
          row "today" do
            with :start, today..(today + 1.day)
          end
          row "tomorrow" do
            with :start, (today + 1.day)..(today + 2.day)
          end
          row "this_week" do
            with :start, this_week..(this_week + 1.week)
          end
          row "this_weekend" do
            with :start, (this_week + 5.day)..(this_week + 7.day)
          end
          row "next_week" do
            with :start, (this_week + 1.week)..(this_week + 2.week)
          end
          row "next_weekend" do
            with :start, (this_week + 12.day )..(this_week + 14.day)
          end
          row "this_month" do
            with :start, (this_month)..(this_month + 1.month)
          end
          row "next_month" do
            with :start, (this_month + 1.month)..(this_month + 2.month)
          end
          row "future" do
            with :start, today..(today + 10.year)
          end
          row "past" do
            with :start, (today - 100.year)..today
          end
          row "christmas_eve" do
            with :start, christmas_eve..(christmas_eve + 1.day)
          end
          row "christmas_day" do
            with :start, (christmas_eve + 1.day)..(christmas_eve + 2.day)
          end
          row "new_years_eve" do
            with :start, new_years_eve..(new_years_eve + 1.day)
          end
          row "walpurgis_night" do
            with :start, (this_year+ 4.month + 29.day)..(this_year + 4.month + 30.day)
          end
        end

        order_by(:start_datetime, :asc)
        # TODO Sök nära mig. # s.near([40,5, -72.3], :distance => 5, :sort => true)


        unless params[:start].blank?
          case
            when params[:start] == "this_week"
              with(:start).between((this_week)..(this_week+1.week))
            when params[:start] == "next_week"
              with(:start).between((this_week+1.week)..(this_week+2.week))
            when params[:start] == "today"
              with(:start).between(today..(today + 1.day))
            when params[:start] == "tomorrow"
              with(:start).between((today + 1.day)..(today + 2.day))
            when params[:start] == "this_weekend"
              with(:start).between((this_week + 5.day)..(this_week + 7.day))
            when params[:start] == "next_weekend"
              with(:start).between((this_week + 12.day )..(this_week + 14.day))
            when params[:start] == "this_month"
              with(:start).between((this_month)..(this_month + 1.month))
            when params[:start] == "next_month"
              with(:start).between((this_month + 1.month)..(this_month + 2.month))
            when params[:start] == "future"
              with(:start).between(today..(today + 10.year))
            when params[:start] == "past"
              with(:start).between((today - 100.year)..today)
            when params[:start] == "christmas_eve"
              with(:start).between(christmas_eve..(christmas_eve + 1.day))
            when params[:start] == "christmas_day"
              with(:start).between((christmas_eve + 1.day)..(christmas_eve + 2.day))
            when params[:start] == "new_years_eve"
              with(:start).between(new_years_eve..(new_years_eve + 1.day))
            when params[:start] == "walpurgis_night"
              with(:start).between((this_year + 4.month + 29.day)..(this_year + 4.month + 30.day ))
          end
        end

      unless params[:start] == "past"
        with(:start).between(today..(today + 10.year))
      else
        with(:start).between((today - 100.year)..today)
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

    if result.facet( :start )
      @start_facet_rows = result.facet(:start).rows
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
    Event.increment_counter :counter, params[:id]
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html
      format.ics
    end
  end


  def new
    @organizers = current_user.select_organizer
    @event = Event.new
    @event.email = current_user.email
    @event.human_name = ''
    unless (current_user.first_name.blank?)
      @event.human_name += current_user.first_name + " "
    end
    unless (current_user.last_name.blank?)
      @event.human_name += current_user.last_name
    end
    @event.human_name.strip!
  end

  def create
    @organizers = current_user.select_organizer
    @event = Event.new(params[:event])
    if @event.save
      OrganizerMailer.new_event_confirmation(@event, current_user).deliver
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
      OrganizerMailer.changed_event_confirmation(@event, current_user).deliver
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
