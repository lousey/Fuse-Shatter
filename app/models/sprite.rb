class Sprite < ActiveRecord::Base
  attr_accessible :file, :name
 
  validates :name,	 :presence => true
 
  has_many :images,	:dependent => :destroy, :order => "created_at ASC"
  belongs_to :user


  def generate
   
    # generate dimensions array to store widths and heights
    dimensions_array = Array.new
    self.images.each do |image|
      i = ::Magick::Image::read(image.file.path).first
      dimensions_array.push([i.columns + image.padding * 2, i.rows + image.padding * 2])
    end

    # calculate image height and image positions
    height_so_far = 0
    row_width_so_far = 0
    row_height_so_far = 0
    positions_array = Array.new
    self.images.each_with_index do |image, index|
      if row_width_so_far + dimensions_array[index][0] > 960
        height_so_far += row_height_so_far
	row_width_so_far = 0
      end
      positions_array.push([row_width_so_far + image.padding, height_so_far + image.padding])
      row_width_so_far += dimensions_array[index][0]
      row_height_so_far = [row_height_so_far, dimensions_array[index][1]].max
    end
    height_so_far += row_height_so_far
        
    # create sprite
    require 'RMagick'
    
    sprite_img = Magick::Image.new(956, height_so_far) { 
      self.background_color = 'none' 
    }
    sprite_img.alpha(Magick::ActivateAlphaChannel)
    self.images.each_with_index do |image, index| 
      current_img = Magick::ImageList.new(image.file.path)
      sprite_img.composite!(current_img, positions_array[index][0], positions_array[index][1], Magick::OverCompositeOp)
    end
    
    require 'fileutils'
    file_path = "#{Rails.root}/public/generated/#{self.id}.png"
    if File.exist?(file_path)
      FileUtils.rm(file_path)
    end 
    sprite_img.write(file_path)
  
    return positions_array
  end

end
