class ProductsController < ApplicationController
  def index
    conditions = {}
    conditions.merge!('info.cast' => params[:actor]) if params[:actor]
    @products = Product.all(:conditions => conditions, :sort => ['title', 1], :limit => 50)
  end
  
  def purchase
    @product = Product.find_by_id(params[:id])
    if Purchase.create(:user => current_user, :product => @product)
      flash[:notice] = "You have purchased '#{@product.title}'"
    else
      flash[:error] = "Problem purchasing '#{@product.title}'"
    end
    redirect_to :back
  end
  
  def show
    @product = Product.find_by_id(params[:id])
  end
end
