class Image < ActiveRecord::Base
  attr_accessible :css_id, :file, :order, :padding
  
  belongs_to :sprite

  validates	  :css_id, :presence => true, :uniqueness => {:scope => :sprite_id}
  validates	  :padding, :presence => true, 
  		  	    :numericality => { :only_integer => true, :greater_than => -1, :less_than => 101 }
  validates_format_of :css_id, :with => /\A-?[_a-zA-Z]+[_a-zA-Z0-9-]*\Z/
  validates_length_of :css_id, :maximum => 50
  validate :validate_image_size

  mount_uploader :file, ImageUploader			   

  before_validation :set_values

  def geometry
    img = ::Magick::Image::read(self.file.path).first
    return [img.columns, img.rows]
  end

  private
  def set_values
    self.padding = 0 if self.padding.nil?
    if self.css_id.nil?
      untaken_id = self.sprite.images.size + 1
      while Image.exists?(:css_id => "sprite-" + untaken_id.to_s)
        untaken_id += 1
      end
      self.css_id = "sprite-" + untaken_id.to_s
    end
  end

  private
  def validate_image_size
    if self.geometry[0] > 500 || self.geometry[1] > 500
       errors.add :image, "must be smaller than 500px by 500px."
    end
  end

end
