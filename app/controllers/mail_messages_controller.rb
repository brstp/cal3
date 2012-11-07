# encoding: UTF-8
class MailMessagesController < ApplicationController

  before_filter :authenticate_user!, :except => [:new, :create, :view]
  before_filter :authorized?, :except => [:new, :create, :view]
  
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

  # GET /mail_messages/1/view
  # For non logged in users
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
    @mail_message.current_page = params[:current_page] if @mail_message.current_page.blank?
    @mail_message.subject = "Felanmälan/anmälan av sida på Allom"
    @mail_message.to_name = "Alloms kundtjänst"
    @mail_message.current_page =  "#{request.protocol}#{request.host_with_port}#{request.fullpath}" if @mail_message.current_page.blank?
    @mail_message.mail_body = "Hej Allom!\n\nJag har en fråga/ett klagomål/vill anmäla/vill felanmäla sidan #{@mail_message.current_page}\n\n"
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
    logger.info "******************************************"
    logger.info @mail_message.from_email
    logger.info "******************************************"
    if @mail_message.save #Opportunity for refactoring #TODO
      unless @mail_message.event_id.nil?
        @mail_message.to_email = Event.find(@mail_message.event_id).email
        ContactFormMailer.delay.event_contact_person(@mail_message)
        ContactFormMailer.delay.copy_self_event_contact(@mail_message)
      else
        unless @mail_message.organizer_id.nil?
          @mail_message.to_email = Organizer.find(@mail_message.organizer_id).email
          ContactFormMailer.delay.organizer_contact_person(@mail_message)
          ContactFormMailer.delay.copy_self_organizer_contact(@mail_message)
        else 
          @mail_message.to_email = "kundtjanst2@allom.se"
          ContactFormMailer.delay.report_page_to_support(@mail_message)
        end
      end
      respond_to do |format|
        format.html { redirect_to view_mail_message_path(@mail_message, 
                      :to_name => @mail_message.to_name,
                      :from_name => @mail_message.from_name,
                      :from_email => @mail_message.from_email,
                      :from_phone => @mail_message.from_phone
                      ), 
                      notice: 'Nu skickar vi iväg ditt mejl. Du får en kopia. Om du inte fått den inom några minuter, kolla om den sorterats som spam av misstag i din mejl.' }
      end
    else
      render :action => 'new'
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
