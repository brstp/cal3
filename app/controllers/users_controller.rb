class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authorized_for_this?, :except => [:index, :new, :create, :destroy]
  before_filter :authorized_admin?, :except => [:show, :update, :edit]

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
      flash[:notice] = "Successfully created user."
      redirect_to @user
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    redirect_to users_url
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