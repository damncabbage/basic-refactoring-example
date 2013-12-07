class ProductsController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "itsasecre7", except: [:index]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def import
    File.open(Rails.root.join('uploads', params[:product][:file].original_filename), 'wb') do |f|
      f.write(params[:product][:file].read)
    end
    flash[:notice] = "Success! Imported #{params[:product][:file].original_filename}"
    redirect_to products_url
  end
end
