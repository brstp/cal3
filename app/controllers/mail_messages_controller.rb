# encoding: UTF-8
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

  def view
    @mail_message = MailMessage.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # GET /mail_messages/new
  def new
    @mail_message = MailMessage.new
    #@event = Event.find 342
    @mail_message.ip = request.remote_ip 
    @mail_message.referer = request.headers["referer"]
    @mail_message.user_agent = request.headers["user_agent"]
    #@mail_message.event_id = @event.id
    #@mail_message.to_name = @event.human_name
    #@mail_message.to_email = @event.email
    @mail_message.current_page = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
    if current_user
      @mail_message.from_email = current_user.try :email
      @mail_message.from_first_name = current_user.try :first_name
      @mail_message.from_last_name = current_user.try :last_name
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /mail_messages/1/edit
  def edit
    @mail_message = MailMessage.find(params[:id])
  end

  # POST /mail_messages
  def create
    @mail_message = MailMessage.new(params[:mail_message])
    respond_to do |format|
      if @mail_message.save
        format.html { redirect_to view_mail_message_path(@mail_message, 
                        :to_name => @mail_message.to_name,
                        :from_name => @mail_message.from_name,
                        :from_email => @mail_message.from_email,
                        :from_phone => @mail_message.from_phone
                        ), 
                        notice: 'Nu skickar vi iväg ditt mejl.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /mail_messages/1
  def update
    render :nothing => true
  end

  # DELETE /mail_messages/1
  def destroy
    @mail_message = MailMessage.find(params[:id])
    @mail_message.destroy

    respond_to do |format|
      format.html { redirect_to mail_messages_url }
    end
  end
  
    
end
