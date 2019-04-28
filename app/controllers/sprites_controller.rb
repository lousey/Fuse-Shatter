class SpritesController < ApplicationController

  before_filter :authenticate_user!, :except => [:index]    

  # GET /sprites
  # GET /sprites.json
  def index
    if current_user
      @sprites = current_user.sprites
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /sprites/1
  # GET /sprites/1.json
  def show
    @sprite = current_user.sprites.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @sprite }
    end
  end

  # GET /sprites/new
  # GET /sprites/new.json
  def new
    @sprite = Sprite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @sprite }
    end
  end

  # GET /sprites/1/edit
  def edit
    @sprite = Sprite.find(params[:id])
  end

  # POST /sprites
  # POST /sprites.json
  def create
    @sprite = Sprite.new(params[:sprite])
    @sprite.user_id = current_user.id
    
    respond_to do |format|
      if @sprite.save
        format.html { redirect_to @sprite, :notice => 'Sprite was successfully created.' }
        format.json { render :json => @sprite, :status => :created, :location => @sprite }
      else
        format.html { render :action => "new" }
        format.json { render :json => @sprite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sprites/1
  # PUT /sprites/1.json
  def update
    @sprite = current_user.sprites.find(params[:id])
    respond_to do |format|
      if @sprite.update_attributes(params[:sprite])
	format.html { redirect_to edit_sprite_path(@sprite), :notice => 'Sprite was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /sprites/1
  # DELETE /sprites/1.json
  def destroy
    @sprite = current_user.sprites.find(params[:id])
    @sprite.destroy

    require 'fileutils'
    file_path = "#{Rails.root}/public/generated/#{@sprite.id}.png"
    if File.exist?(file_path)
      FileUtils.rm(file_path)
    end

    respond_to do |format|
      format.html { redirect_to sprites_url }
      format.json { head :no_content }
    end
  end

  # PUT /sprites/1
  # PUT /sprites/1.json
  def upload
    @sprite = current_user.sprites.find(params[:id])
    failed_save = nil
    if !params[:image].nil?
      params[:image].each do |uploaded_image|
        im = Image.new
        im.file = uploaded_image
        im.sprite_id = @sprite.id
        if !im.save
           failed_save = im
        end
      end
    end
    @sprite = current_user.sprites.find(params[:id])
    respond_to do |format|
      if failed_save.blank?
        if !params[:image].nil?
           format.html { redirect_to @sprite, :notice => 'Images were successfully uploaded.' }
        else
           format.html { redirect_to @sprite }
        end
      else
        format.html { redirect_to @sprite, :alert => failed_save.errors.full_messages[0] }
      end
    end
  end

  def generate
    @sprite = current_user.sprites.find(params[:id])
    @positions = @sprite.generate
    respond_to do |format|
      if @sprite.images.size > 0
        flash.now[:notice] = 'Sprite generated!'
        format.html { render :action => "show" }
      else
        format.html { redirect_to @sprite }
      end
    end  
  end

end
