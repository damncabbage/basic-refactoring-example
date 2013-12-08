require 'csv'
require 'open-uri'

class ProductsController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "itsasecre7", except: [:index]
  respond_to :html

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    product_params = params.require(:product).permit(:name, :price)
    @product = Product.create(product_params)
    flash[:notice] = "Product was successfully created." if @product.persisted?
    respond_with @product, location: products_url
  end

  def destroy
    @product = Product.destroy(params[:id])
    flash[:notice] = "Product was successfully destroyed." unless @product.persisted?
    respond_with @product, location: products_url
  end

  def import
    products = []
    p params[:product]
    CSV.foreach(params[:product][:file].path, headers: true) do |row|
# todo clean up
      product = Product.new(
        name:  row['name'],
        price: row['price'],
      )
			product.photo = open(row['thumbnail_url']) if row['thumbnail_url'].present?
      if !product.save
        flash[:warning] = "Could not save product! #{product.errors.messages}"
    		# render :status => 422, :html => "bad product" and return
        redirect_to products_url
      end
      products << product
    end
    if params[:product][:notify]
      ImportResultMailer.result_email(products).deliver
    end
    flash[:notice] = "Success! Imported #{params[:product][:file].original_filename}"
    redirect_to products_url
  end
end
