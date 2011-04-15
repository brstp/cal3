# encoding: UTF-8
class PetitionsController < ApplicationController
  def index
    @petitions = Petition.all
  end

  def show
    @petition = Petition.find(params[:id])
  end

  def new
    @petition = Petition.new
    @user = current_user
    @petition.user_id = current_user.id
    @petition.organizer_id = params[:organizer_id]
    if @petition.organizer_id.blank?
      @petition.organizer_id = 2 # TODO debug
    end
  end

  def create
    @petition = Petition.new(params[:petition])
    if @petition.save
      redirect_to @petition, :notice => "Din ansökan är klar. Nu kommer arrangören att behandla den."
    else
      render :action => 'new'
    end
  end

  def edit
    @petition = Petition.find(params[:id])
    @petition.decision_made_by_user = current_user
  end

  def update
    @petition = Petition.find(params[:id])
    if @petition.update_attributes(params[:petition])
      redirect_to @petition, :notice  => "Ansökan behandlad och sparad" # TODO different notices depending on decision.
    else
      render :action => 'edit'
    end
  end

  def destroy
    @petition = Petition.find(params[:id])
    @petition.destroy
    redirect_to petitions_url, :notice => "Du har dragit tillbaka din ansökan."
  end
end
