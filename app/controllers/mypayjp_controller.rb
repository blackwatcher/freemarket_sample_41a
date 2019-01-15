class MypayjpController < ApplicationController
  before_action :set_product, only: [:show, :create_chage]

require 'payjp'

  def show
    @user = current_user
    @area = Area.find_by(id: current_user.address.prefecture)
    @product_images = ProductImage.find_by(product_id: params[:id])
  end

  def create_charge
    customer_id = current_user.payjp_id
    point = params[:price].to_i
    amount = @product.price - point
    if current_user.point
      save_users_point(point, amount)
    end

    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    PaysHelper.create_charge(amount, customer_id)
    Trade.transaction do
      @trade = Trade.find_by(product_id: params[:id])
      @trade.deal = true
      @trade.save
      save_sellers_point(@product, amount)
    end

    redirect_to root_path
    rescue
    redirect_to  product_path
  end

  def set_product
    @product = Product.find(params[:id])
  end

end