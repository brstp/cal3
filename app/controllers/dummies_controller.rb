class DummiesController < ApplicationController
  # GET /dummies
  # GET /dummies.json
  def index
    @dummies = Dummy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dummies }
    end
  end

  # GET /dummies/1
  # GET /dummies/1.json
  def show
    @dummy = Dummy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dummy }
    end
  end

  # GET /dummies/new
  # GET /dummies/new.json
  def new
    @dummy = Dummy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dummy }
    end
  end

  # GET /dummies/1/edit
  def edit
    @dummy = Dummy.find(params[:id])
  end

  # POST /dummies
  # POST /dummies.json
  def create
    @dummy = Dummy.new(params[:dummy])

    respond_to do |format|
      if @dummy.save
        format.html { redirect_to @dummy, notice: 'Dummy was successfully created.' }
        format.json { render json: @dummy, status: :created, location: @dummy }
      else
        format.html { render action: "new" }
        format.json { render json: @dummy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dummies/1
  # PUT /dummies/1.json
  def update
    @dummy = Dummy.find(params[:id])

    respond_to do |format|
      if @dummy.update_attributes(params[:dummy])
        format.html { redirect_to @dummy, notice: 'Dummy was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @dummy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dummies/1
  # DELETE /dummies/1.json
  def destroy
    @dummy = Dummy.find(params[:id])
    @dummy.destroy

    respond_to do |format|
      format.html { redirect_to dummies_url }
      format.json { head :ok }
    end
  end
end
