class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_admin, only: [:index, :places, :transports, :finishes]
  before_action :load_payment, except: [:index, :show]
  before_action :load_order, only: [:show, :edit, :update, :destroy]
  before_action :load_order_items, :calculate_total, only: :show
  before_action :allow_edit_and_destroy, only: [:edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @search = Order.ransack params[:q]
    @pagy, @orders = pagy @search.result, items: params[:item]
  end

  def show; end

  def new
    @order = Order.new
  end

  def edit; end

  def create
    @order = Order.new order_params
    begin
      ActiveRecord::Base.transaction do
        @order.save
        save_order_items @cart, @order
        @order.send_email_for_customer
        @order.send_email_for_admin
        session.delete :cart
        flash[:success] = t ".success"
        redirect_to root_path
      end
    rescue StandardError
      flash[:danger] = t ".fail"
      render :new
    end
  end

  def update
    if @order.update order_params
      flash[:success] = t ".success"
      redirect_to orders_user_path current_user
    else
      flash.now[:danger] = t ".fail"
      render :edit
    end
  end

  def destroy
    if @order.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_back fallback_location: root_path
  end

  def places
    @places = Order.place.paginate page: params[:page],
      per_page: Settings.items
  end

  def transports
    @transports = Order.transport.paginate page: params[:page],
      per_page: Settings.items
  end

  def finishes
    @finishes = Order.finish.newest.paginate page: params[:page],
      per_page: Settings.items
  end

  private

  def order_params
    params.require(:order).permit Order::ORDER_PARAMS
  end

  def load_payment
    @payments = Payment.all
  end

  def save_order_items cart, order
    all_items = []
    cart.each do |key, value|
      product = Product.find_by id: key
      price = price_for product
      all_items.push(product_id: key.to_i, quantity: value, price: price)
    end
    order.order_items.create(all_items)
  end

  def allow_edit_and_destroy
    user = User.find_by email: @order.email
    return if current_user == user && @order.place?
    flash[:danger] = t ".can't"
    redirect_to current_user
  end

  def load_order_items
    @order_items = @order.order_items.includes(:product)
  end

  def calculate_total
    @total = @order_items.reduce(0) do |sum, item|
      sum + item.quantity * item.price
    end
  end
end
