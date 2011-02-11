class MailMessagesController < ApplicationController
before_filter :authenticate_user!, :except => [:new, :create]
before_filter :authorized?, :except => [:new, :create]
  
  # GET /mail_messages
  def index
    @mail_messages = MailMessage.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /mail_messages/1
  def show
    @mail_message = MailMessage.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /mail_messages/new
  def new
    @mail_message = MailMessage.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /mail_messages
  def create
    @mail_message = MailMessage.new(params[:mail_message])
    @mail_message.to_email = Event.find(@mail_message.event_id).email
    
    if current_user
      time_to_save = false
      if current_user.first_name.blank? and !@mail_message.from_first_name.blank?
        current_user.first_name = @mail_message.from_first_name
        time_to_save = true
      end
      if current_user.last_name.blank? and !@mail_message.from_last_name.blank?
        current_user.last_name = @mail_message.from_last_name
        time_to_save = true
      end      
      current_user.save if time_to_save
    end

    respond_to do |format|
      if @mail_message.save
        EventMailer.copy_event_sender(@mail_message).deliver
        EventMailer.contact_event(@mail_message).deliver
        format.html { redirect_to(Event.find(@mail_message.event_id), :notice => I18n.t('flash.actions.create.sent')) } 
      else
        format.html { render :action => "new" }
      end
    end
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
