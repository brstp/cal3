# encoding: UTF-8

class SyndicationsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /syndications
  def index
    if current_user.is_admin?
      @syndications = Syndication.all
    else
      @syndications = current_user.syndications
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /syndications/new
  def new
    @syndication = Syndication.new
    @syndication.syndicated_organizer_id = params[:syndicated_organizer_id]
    @organizers = current_user.organizers
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /syndications
  def create
    organizer = Organizer.find(params[:syndication][:organizer_id])
    params[:syndication].delete(:organizer_id) unless (current_user.try(:is_admin?) || current_user.authorized?(organizer)) 
    
    @syndication = Syndication.new(params[:syndication])

    respond_to do |format|
      if @syndication.save
        format.html { redirect_to syndications_url, notice: "#{@syndication.organizer.name} visar nu evenemang från #{@syndication.syndicated_organizer.name} på sin arrangörssida." }
      else
        format.html { render action: "new" }
      end
    end
  end


  # DELETE /syndications/1
  def destroy
    if current_user.is_admin?
      @syndication = Syndication.find(params[:id])
    else
      @syndication = current_user.syndications.find(params[:id])
    end
    @syndication.destroy

    respond_to do |format|
      format.html { redirect_to syndications_url, notice: "Så, då plockade vi bort visningen av den arrangörens evenemang. Du kan lätt lägga till igen om du ångrar dig." }
    end
  end
end
