class AlmanacDaysController < ApplicationController
  
  before_filter :authorized?
  # GET /almanac_days
  # GET /almanac_days.json
  def index
    @almanac_days = AlmanacDay.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @almanac_days }
    end
  end

  # GET /almanac_days/1
  # GET /almanac_days/1.json
  def show
    @almanac_day = AlmanacDay.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @almanac_day }
    end
  end

  # GET /almanac_days/new
  # GET /almanac_days/new.json
  def new
    @almanac_day = AlmanacDay.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @almanac_day }
    end
  end

  # GET /almanac_days/1/edit
  def edit
    @almanac_day = AlmanacDay.find(params[:id])
  end

  # POST /almanac_days
  # POST /almanac_days.json
  def create
    @almanac_day = AlmanacDay.new(params[:almanac_day])

    respond_to do |format|
      if @almanac_day.save
        format.html { redirect_to @almanac_day, notice: 'Almanac day was successfully created.' }
        format.json { render json: @almanac_day, status: :created, location: @almanac_day }
      else
        format.html { render action: "new" }
        format.json { render json: @almanac_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /almanac_days/1
  # PUT /almanac_days/1.json
  def update
    @almanac_day = AlmanacDay.find(params[:id])

    respond_to do |format|
      if @almanac_day.update_attributes(params[:almanac_day])
        format.html { redirect_to @almanac_day, notice: 'Almanac day was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @almanac_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /almanac_days/1
  # DELETE /almanac_days/1.json
  def destroy
    @almanac_day = AlmanacDay.find(params[:id])
    @almanac_day.destroy

    respond_to do |format|
      format.html { redirect_to almanac_days_url }
      format.json { head :ok }
    end
  end
  
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
