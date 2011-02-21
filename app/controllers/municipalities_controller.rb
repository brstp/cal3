class MunicipalitiesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :authorized?, :except => [:show, :index]
  
  def index
    @municipalities = Municipality.all(:order => 'name ASC')
  end
  
  def show
    @municipality = Municipality.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.ihtml
        format.rss  
        format.ics
      end
  end
  
  def new
    @municipality = Municipality.new
  end
  
  def create
    @municipality = Municipality.new(params[:municipality])
    if @municipality.save
      flash[:notice] = t 'flash.actions.create.notice'
      redirect_to @municipality
    else
      render :action => 'new'
    end
  end
  
  def edit
    @municipality = Municipality.find(params[:id])
  end
  
  def update
    @municipality = Municipality.find(params[:id])
    if @municipality.update_attributes(params[:municipality])
      flash[:notice] = t('flash.actions.update.notice')
      redirect_to @municipality
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @municipality = Municipality.find(params[:id])
    @municipality.destroy
    flash[:notice] = t 'flash.actions.destroy.notice'
    redirect_to municipalities_url
  end


protected

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
