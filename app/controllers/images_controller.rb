class ImagesController < ApplicationController
  before_filter :authenticate_user!

  # GET /sprites/1
  # GET /sprites/1.json
  def show
    @image = current_user.sprites.find(params[:sprite_id]).images.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def update
    @image = current_user.sprites.find(params[:sprite_id]).images.find(params[:id])
    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to @image.sprite, :notice => 'Image was successfully updated.' }
      else
        format.html { redirect_to @image.sprite, :alert => @image.errors.full_messages[0] }
      end
    end
  end

  def destroy
    @image = current_user.sprites.find(params[:sprite_id]).images.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to sprite_url(params[:sprite_id]) }
    end
  end

end
