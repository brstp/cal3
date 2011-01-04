class MailMessagesController < ApplicationController

  

  
  # GET /mail_messages
  # GET /mail_messages.xml
  def index
    @mail_messages = MailMessage.all

    respond_to do |format|
      format.html # index.html.erb
      # format.xml  { render :xml => @mail_messages }
    end
  end

  # GET /mail_messages/1
  # GET /mail_messages/1.xml
  def show
    @mail_message = MailMessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      # format.xml  { render :xml => @mail_message }
    end
  end

  # GET /mail_messages/new
  # GET /mail_messages/new.xml
  def new
    @mail_message = MailMessage.new
    @mail_message.ip = request.remote_ip
    @mail_message.referer = request.headers["referer"]
    @mail_message.user_agent = request.headers["user_agent"]
    @mail_message.event_id = 999
    @mail_message.to_name = "Nisse"
    @mail_message.to_email = "stefan@lumano.se"
    if current_user
      @mail_message.from_email = current_user.try :email
      @mail_message.from_first_name = current_user.try :first_name
      @mail_message.from_last_name = current_user.try :last_name
    end
    respond_to do |format|
      format.html # new.html.erb
      # format.xml  { render :xml => @mail_message }
    end
  end

  # GET /mail_messages/1/edit
  # def edit
    # @mail_message = MailMessage.find(params[:id])
  # end

  # POST /mail_messages
  # POST /mail_messages.xml
  def create
    @mail_message = MailMessage.new(params[:mail_message])
    respond_to do |format|
      if @mail_message.save
        @mail_message.ip = request.remote_ip
        @mail_message.referer = request.headers["referer"]
        @mail_message.user_agent = request.headers["user_agent"]
        EventMailer.contact_event(@mail_message).deliver
        format.html { redirect_to(@mail_message, :notice => I18n.t('flash.actions.create.sent')) } # TODO Change redirect to event.
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @mail_message.errors, :status => :unprocessable_entity }
      end
    end
  end


      
  # PUT /mail_messages/1
  # PUT /mail_messages/1.xml
  # def update
    # @mail_message = MailMessage.find(params[:id])

    # respond_to do |format|
      # if @mail_message.update_attributes(params[:mail_message])
        # format.html { redirect_to(@mail_message, :notice => 'Mail message was successfully updated.') }
        # format.xml  { head :ok }
      # else
        # format.html { render :action => "edit" }
        # format.xml  { render :xml => @mail_message.errors, :status => :unprocessable_entity }
      # end
    # end
  # end

  # DELETE /mail_messages/1
  # DELETE /mail_messages/1.xml
  # def destroy
    # @mail_message = MailMessage.find(params[:id])
    # @mail_message.destroy

    # respond_to do |format|
      # format.html { redirect_to(mail_messages_url) }
      # format.xml  { head :ok }
    # end
  # end
end
