class MembershipsController < ApplicationController
  def index
    @memberships = Membership.all
  end

  def show
    @membership = Membership.find(params[:id])
    @organizer = Organizer.find @membership.organizer_id
    @user = User.find @membership.user_id
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


  
  
  def nominate  # admin nominate from undefinied to nominated
    @membership = Membership.new(params[:membership])
    if @membership.save
      redirect_to @membership, :notice => "Successfully created membership."
    else
      render :action => 'new'
    end  
  end

  def apply  # user apply from undefined to applied
    @membership = Membership.new(params[:membership])
    if @membership.save
      redirect_to @membership, :notice => "Successfully created membership."
    else
      render :action => 'new'
    end
  end
  

  
  def no_thanks
  end
  
  def degrade
  end
  
  def approve
  end
  
  def reject
  end
  
  def cancel
  end
  
  def  promote
  end

  def  promote
  end
  

  def destroy  # TODO remove.
    @membership = Membership.find(params[:id])
    @membership.destroy
    redirect_to memberships_url, :notice => "Successfully destroyed membership."
  end
  
  def regret # user regret from applied to resigned
    @membership = Membership.find(params[:id])
    @membership.regretted_at = Time.now
    @membership.state = "resigned"
    logger.info "##### regret #### state at comment"
    logger.info @membership.state
    logger.info @membership.regretted_at
    render :action => :edit
    if @membership.save
      logger.info "------ yes ---------"
    else
      logger.info "------  No ---------"
      
      # format.html { render :action => 'organizers/show'}
    end
  end
  

  
  def admin_ack # admin acknowledge from inform_admin to destroy
    @membership = Membership.find(params[:id])  
    @membership.destroy
    redirect_to memberships_url, :notice => "#admin_ack Successfully destroyed membership."
  end
  
  def user_ack  # user acknowledge from inform_user to destroy
    @membership = Membership.find(params[:id])  
    @membership.destroy
    redirect_to memberships_url, :notice => "#user_ack Successfully destroyed membership."
  end
  
end
