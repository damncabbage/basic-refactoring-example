class Product < ActiveRecord::Base
  after_create :created

  validates_presence_of :name, :price

  def created
    self.sku = name.upcase.gsub(/[^A-Z]/, '')[0..4] + sprintf("%05d", id)
    save!
  end
end
