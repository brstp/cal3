class MailMessagesController < ApplicationController
  
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
    respond_to do |format|
      if @mail_message.save
        EventMailer.contact_event(@mail_message).deliver
        format.html { redirect_to(Event.find(@mail_message.event_id), :notice => I18n.t('flash.actions.create.sent')) } 
      else
        format.html { render :action => "new" }
      end
    end
  end

end
