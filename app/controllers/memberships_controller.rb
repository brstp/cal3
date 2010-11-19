class MembershipsController < ApplicationController
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
      flash[:notice] = "Successfully created membership."
      redirect_to @membership
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
      flash[:notice] = "Successfully updated membership."
      redirect_to @membership
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
    flash[:notice] = "Successfully destroyed membership."
    redirect_to memberships_url
  end
end
