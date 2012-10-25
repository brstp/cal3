# encoding: UTF-8
class UsersController < ApplicationController
  #TODO Move flash messages to I18n
  before_filter :authenticate_user!
  before_filter :authorized_for_this?, :except => [:index, :new, :create, :destroy]
  before_filter :authorized_admin?, :except => [:show, :update, :edit]
  before_filter :remove_admin_params, :only => [:create, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create 
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Användarkontot skapat."
      redirect_to @user
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id]) #todo scope
  end

  def update
    @user = User.find(params[:id]) #todo scope
    if @user.update_attributes(params[:user]) #todo mass assignment!
      flash[:notice] = "Uppdaterat användarkontot."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Användarkontot raderat."
    redirect_to users_url
  end

  def coronate
    @user = User.find(params[:id])
    @user.update_column 'is_admin', (params[:is_admin].to_i == 1)
    flash[:notice] = "Ändrat om användaren är systemadministratör"
    redirect_to user_path(@user)
  end

protected

  def authorized_admin?
    unless current_user
      flash[:alert] = t 'flash.actions.not_authenticated'
      redirect_to :back
    else
      unless current_user.is_admin?
        flash[:alert] = t 'flash.actions.not_admin'
        redirect_to :root #TODO if refer set --> :back
      end
    end
  end


  def authorized_for_this?
    unless current_user
      flash[:alert] = t 'flash.actions.not_authenticated'
      redirect_to :back
    else
      unless (current_user == User.find(params[:id])) or (current_user.is_admin?)
        flash[:alert] = t 'flash.actions.not_you'
        redirect_to :back
      end
    end
  end

end