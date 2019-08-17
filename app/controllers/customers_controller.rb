class CustomersController < ApplicationController
  def index
    @q = Customer.where(is_deleted: false).order(id: :asc).ransack(params[:q])
    @customers = @q.result(distinct: true)
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to @customer, notice: "顧客「#{@customer.customer_name}」を登録しました"
    else
      render :new
    end
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    customer = Customer.find(params[:id])
    customer.update!(customer_params)
    redirect_to customers_url: "顧客「#{customer.customer_name}」を更新しました。"
  end

  def destroy
    customer = Customer.find(params[:id])
    customer.update!(is_deleted: true, deleted_at: DateTime.now)
    redirect_to customers_url, notice: "顧客「#{customer.customer_name}」を削除しました。"
  end

  private

  def customer_params
    params.require(:customer).permit(:customer_name, :customer_name_kana, :customer_initial, :postal_code, :address,
                                     :tel, :fax, :remarks)
  end
end
