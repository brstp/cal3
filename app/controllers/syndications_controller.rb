# encoding: UTF-8

class SyndicationsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /syndications
  # GET /syndications.json
  def index
    #@syndications = Syndication.all
    @syndications = current_user.syndications

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @syndications }
    end
  end

  # GET /syndications/1
  # GET /syndications/1.json
  def show
    @syndication = Syndication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @syndication }
    end
  end

  # GET /syndications/new
  # GET /syndications/new.json
  def new
    @syndication = Syndication.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @syndication }
    end
  end

  # GET /syndications/1/edit
  def edit
    @syndication = Syndication.find(params[:id])
  end

  # POST /syndications
  # POST /syndications.json
  def create
    @syndication = Syndication.new(params[:syndication])

    respond_to do |format|
      if @syndication.save
        format.html { redirect_to @syndication, notice: 'Syndication was successfully created.' }
        format.json { render json: @syndication, status: :created, location: @syndication }
      else
        format.html { render action: "new" }
        format.json { render json: @syndication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /syndications/1
  # PUT /syndications/1.json
  def update
    @syndication = Syndication.find(params[:id])

    respond_to do |format|
      if @syndication.update_attributes(params[:syndication])
        format.html { redirect_to @syndication, notice: 'Syndication was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @syndication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /syndications/1
  # DELETE /syndications/1.json
  def destroy
    @syndication = Syndication.find(params[:id])
    @syndication.destroy

    respond_to do |format|
      format.html { redirect_to syndications_url }
      format.json { head :no_content }
    end
  end
end
