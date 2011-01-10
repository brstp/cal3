class MembershipsController < ApplicationController

before_filter :authenticate_user!
before_filter :authorized_to_create?, :except => [:destroy]
before_filter :authorized_to_destroy?, :except => [:create]
  
  def create
    organizer_id = params[:organizer_id]
    user_id = params[:user_id]
    unless Membership.find(:all, :conditions => ["organizer_id = ? and user_id = ?", organizer_id, user_id]).blank?
      flash[:alert] = I18n.t 'flash.actions.create.membership_exists_already'
      redirect_to :back      
    else
      logger.info "--------------" + organizer_id
      @organizer = Organizer.find( organizer_id )
      @membership = @organizer.memberships.build(:user_id => user_id )
      if @membership.save
        # TODO remove from prospects
        flash[:notice] = I18n.t 'flash.actions.create.added_membership'
        redirect_to :back
      else
        flash[:alert] = I18n.t 'flash.actions.create.couldnt_save_membership'
        redirect_to :back
      end
    end 
  end
  
  
  def destroy
    @membership = Membership.find(params[:id])
    if @membership.user == current_user
      flash[:alert] = I18n.t 'flash.actions.destroy.dont_delete_own_membership'
    else
      @membership.destroy
      flash[:notice] = I18n.t 'flash.actions.destroy.membership_removed'
    end
    redirect_to :back
  end
  
  protected
  
  def authorized_to_create?
    unless current_user
      flash[:alert] = t 'flash.actions.not_authenticated'
      redirect_to :back
    else
      @organizer = Organizer.find( params[:organizer_id] )
      if !current_user.organizers.include? @organizer and !current_user.is_admin?
        flash[:alert] = t 'flash.actions.not_member_here'
        redirect_to :back
      else
        # do stuff
      end
    end  
  end

  def authorized_to_destroy?
    unless current_user
      flash[:alert] = t 'flash.actions.not_authenticated'
      redirect_to :back
    else
      @membership = Membership.find( params[:id] )
      if !current_user.organizers.include? @membership.organizer  #and !current_user.is_admin?
        flash[:alert] = t 'flash.actions.not_member_here'
        redirect_to :back
      else
        # do stuff
      end
    end  
  end
  
end
