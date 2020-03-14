class ProductsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :only_admin, only: :index
  before_action :load_category, except: [:index, :show, :destroy]
  before_action :load_product, except: [:index, :new, :create]
  before_action :allow_destroy, only: :destroy
  before_action :load_evaluates, only: :show
  load_and_authorize_resource

  def index
    @search = Product.includes(:category).ransack params[:q]
    @products = @search.result.page params[:page]
    @products = @products.per_page params[:item].to_i if params[:item].present?
  end

  def show
    @evaluate = Evaluate.new
  end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t ".success"
      redirect_to products_path
    else
      render :new
    end
  end

  def update
    if @product.update product_params
      flash[:success] = t ".success"
      redirect_to products_path
    else
      flash.now[:danger] = t ".fail"
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to products_path
  end

  def restore
    if @product.restore recursive: true
      flash[:success] = t ".restored"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to trash_admin_index_path
  end

  def hard_destroy
    if @product.really_destroy!
      flash[:success] = t ".deleted"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to trash_admin_index_path
  end

  private

  def load_product
    @product = Product.with_deleted.find_by id: params[:id]
    return if @product
    flash[:danger] = t ".not_found"
    redirect_to products_path
  end

  def product_params
    params.require(:product).permit :name, :image, :price, :discount,
      :sold_many, :description, :category_id, :close_discount_at
  end

  def allow_destroy
    exist_order_item = @product.order_items
    return if exist_order_item.empty?
    flash[:danger] = t ".fail"
    redirect_to products_path
  end

  def load_evaluates
    @evaluates = @product.evaluates.recently.paginate page: params[:page],
      per_page: Settings.items
    @count_rating = @evaluates.size
    @avg_star = @product.evaluates.average(:star).to_f.round(1)
  end
end
