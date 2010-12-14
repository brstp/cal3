class OrganizersController < ApplicationController

before_filter :authenticate_user!, :except => [:show, :index]
before_filter :authorized?, :except => [:show, :index]
before_filter :authorized_for_this?, :except => [:show, :index, :new, :create]

  def index
    @organizers = Organizer.all
  end
  
  def show
    @organizer = Organizer.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.rss  
    end
  end
  
  
  def new
    @organizer = Organizer.new
  end
  
  
  def create
    @organizer = Organizer.new(params[:organizer])
    if @organizer.save
      flash[:notice] = t 'flash.actions.create.notice'
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
    if @organizer.update_attributes(params[:organizer])
      flash[:notice] = t 'flash.actions.update.notice'
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
      logger.info "current_user: " + current_user.email
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
