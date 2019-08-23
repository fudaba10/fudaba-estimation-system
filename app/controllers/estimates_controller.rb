class EstimatesController < ApplicationController
  def index
#     @estimates = EstimateHeader.joins(:estimate_details, :customer)
#                     .select("estimate_headers.id, customers.customer_name,
# estimate_headers.customer_person, estimate_headers.estimate_id, estimate_details.product_name")

    @q = EstimateHeader.joins(:estimate_details, :customer)
             .where(is_deleted: false)
             .order(created_at: :desc)
             .select("estimate_headers.id, customers.customer_name, estimate_headers.customer_person,
estimate_headers.estimate_id, estimate_details.product_name,
estimate_headers.created_at, estimate_headers.updated_at").ransack(params[:q])
    @estimates = @q.result(distinct: true)
    logger.debug('このした')

    logger.debug(@estimates)
  end

  def new
    @estimate_h = EstimateHeader.new
    @estimate_d = EstimateDetail.new
  end

  def create
    d = Date.today
    d.strftime("%y%m%d")
    @estimate = EstimateHeader.new
    eh_param = estimate_params
    @estimate.employee = current_user
    @estimate.customer = Customer.find(eh_param[:customer].to_i)
    @estimate.customer_person = eh_param[:customer_person]
    # TODO Header:id が存在しない場合、1で登録する。
    @estimate.estimate_id =
        @estimate.customer.customer_initial + d.strftime + '−' + (EstimateHeader.last[:id] +1).to_s
    if @estimate.save

    else
      render :new
    end
    @estimate_d = EstimateDetail.new
    ed_param = estimate_params[:estimate_d]
    @estimate_d.product_name = ed_param[:product_name]
    @estimate_d.detail = ed_param[:detail]
    @estimate_d.quantity = ed_param[:quantity].to_i
    @estimate_d.kind = ed_param[:kind]
    @estimate_d.unit_price = ed_param[:unit_price].to_i
    @estimate_d.total_fee = @estimate_d.quantity * @estimate_d.unit_price
    @estimate_d.tax = @estimate_d.total_fee * 0.1
    @estimate_d.tax_amount = @estimate_d.total_fee + @estimate_d.tax
    @estimate_d.vendor = Vendor.find(ed_param[:vendor].to_i)
    @estimate_d.estimate_header_id = EstimateHeader.last[:id]
    @estimate_d.estimate_detail_id = 1

    if @estimate_d.save
      redirect_to estimates_url, notice: "見積書「#{@estimate.estimate_id}」を登録しました"
    else
      render :new
    end
  end

  def show
    @estimate = EstimateHeader.find(params[:id])
  end

  def edit
  end

  #取得したparamsを数値化
  def integer_string?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end

  private

  def estimate_params
    params.require(:estimate_header).permit(
        :customer, :customer_person, :estimate_id,
        estimate_d: [:product_name, :detail, :quantity, :kind, :unit_price, :delivery_period, :vendor])
  end

  def params_int(estimate_params)
    estimate_params.each do |key,value|
      if integer_string?(value)
        estimate_params[key]=value.to_i
      end
    end

  end

end
