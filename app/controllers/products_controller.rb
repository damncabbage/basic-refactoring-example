require 'csv'

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
    CSV.foreach(params[:product][:file].path, headers: true) do |row|
      products << Product.create(
        name:  row['name'],
        price: row['price'],
      )
    end
    ImportResultMailer.result_email(products).deliver
    flash[:notice] = "Success! Imported #{params[:product][:file].original_filename}"
    redirect_to products_url
  end

  protected

    def product_params
      params.require(:product).permit(:name, :price)
    end
end
