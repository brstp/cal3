# encoding: UTF-8
class PetitionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :is_admin?, :only => [:index]
  before_filter :my_own?, :only => [:destroy]
  before_filter :is_organizer?, :only => [:edit, :update]
  before_filter :is_own_or_organizer?, :only => [:show]

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
  end

  def create
    @user = User.find(params[:petition][:user_attributes][:id])
    @user.update_attributes(params[:petition][:user_attributes])
    @user.update_attribute 'name_required', true
    args = params[:petition]
    @petition = Petition.new( :organizer_id => args[:organizer_id],
                              :user_id => args[:user_id],
                              :argumentation => args[:argumentation])
    if @petition.save
      redirect_to @petition, :notice => t('petition.flash.notice.created')
      OrganizerMailer.delay.new_petition(@petition, current_user)
    else
      render :action => 'new'
    end
  end

  def edit
    @petition = current_user.applications.find(params[:id])
    @petition.decision_made_by_user = current_user
  end

  def update
    @petition = current_user.applications.find(params[:id])
    if @petition.update_attributes(params[:petition])
      if @petition.approved
        @petition.promote_to_membership
        OrganizerMailer.delay.approved_petition(@petition, current_user)
        # TODO logging
        @petition.destroy
        flash[:notice] = t('petition.flash.notice.approved')
        redirect_to organizer_path(@petition.organizer)
      else
        OrganizerMailer.delay.rejected_petition(@petition, current_user)
        # TODO logging
        @petition.destroy
        flash[:notice] = t('petition.flash.notice.rejected')
        redirect_to organizer_path(@petition.organizer)
      end

    else
      render :action => 'edit'
    end
  end

  def destroy
    @petition = current_user.petitions.find(params[:id])
    organizer = @petition.organizer
    @petition.destroy
    redirect_to organizer, :notice => t('petition.flash.notice.destroyed' )
  end

protected

  def is_admin?
    unless current_user.is_admin?
      flash[:alert] = t 'devise.failure.not_admin'
      if request.env["HTTP_REFERER"].blank?
        redirect_to :root
      else
        redirect_to  :back
      end
    end
  end

  def is_organizer?
    @petition = Petition.find(params[:id])
    unless (@petition.organizer.users.include? current_user) || current_user.is_admin?
      flash[:alert] = t('devise.failure.not_organizer')
      if request.env["HTTP_REFERER"].blank?
        redirect_to :root
      else
        redirect_to  :back
      end
    end
  end

  def my_own?
    @petition = Petition.find(params[:id])
    unless (@petition.user == current_user) || current_user.is_admin?
      flash[:alert] = t('devise.failure.not_mine')
      if request.env["HTTP_REFERER"].blank?
        redirect_to :root
      else
        redirect_to :back
      end
    end
  end

  def is_own_or_organizer?
    @petition = Petition.find(params[:id])
    unless (@petition.user == current_user) || (@petition.organizer.users.include? current_user) || current_user.is_admin?
      flash[:alert] = t('devise.failure.not_mine')
      if request.env["HTTP_REFERER"].blank?
        redirect_to :root
      else
        redirect_to :back
      end
    end
  end


end
