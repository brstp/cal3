# encoding: UTF-8
class MembershipsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :is_admin?, :except => [:destroy]
  before_filter :is_organizer_but_not_mine?, :only => [:destroy]
 

  def index
    @memberships = Membership.all
  end

  def show
    @membership = Membership.find(params[:id])
  end

  def new
    @membership = Membership.new
  end

  def create
    @membership = Membership.new(params[:membership])
    if @membership.save
      redirect_to @membership, :notice => "Successfully created membership."
    else
      render :action => 'new'
    end
  end

  def edit
    @membership = Membership.find(params[:id])
  end

  def update
    @membership = Membership.find(params[:id])
    if @membership.update_attributes(params[:membership])
      redirect_to @membership, :notice  => "Successfully updated membership."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @membership = Membership.find(params[:id])
    OrganizerMailer.cancelled_membership(@membership, current_user).deliver
    @membership.destroy
    flash[:notice] = t('membership.flash.notice.destroyed')
    if request.env["HTTP_REFERER"].blank?
      redirect_to :root
    else
      redirect_to  :back   
    end
  end
  
  protected
  
  def is_admin?  
    logger.info "------------- is_admin? --------------"
    unless current_user.is_admin?
      flash[:alert] = t 'devise.failure.not_admin'
      if request.env["HTTP_REFERER"].blank?
        redirect_to :root
      else
        redirect_to  :back      
      end
    end
  end
  
  def is_organizer_but_not_mine?
    logger.info "------------- is_organizer_but_not_mine? --------------"
    @membership = Membership.find(params[:id])
    logger.info @membership.organizer.users
    return if current_user.is_admin?
    
    unless @membership.organizer.users.include? current_user
      flash[:alert] = t('devise.failure.not_organizer')
      if request.env["HTTP_REFERER"].blank?
        redirect_to :root
      else
        redirect_to  :back      
      end
    end
    
    if (@membership.user == current_user) 
      flash[:alert] = t('membership.flash.failure.dont_resign')
      if request.env["HTTP_REFERER"].blank?
        redirect_to :root
      else
        redirect_to  :back      
      end
    end
  end
  
end

