class Product < ActiveRecord::Base
  after_create :created
  mount_uploader :photo, ProductPhotoUploader
  validates_presence_of :name, :price

  def created
    self.sku = name.upcase.gsub(/[^A-Z]/, '')[0..4] + sprintf("%05d", id)
    save!
  end
end
