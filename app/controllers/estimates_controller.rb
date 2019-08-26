class EstimatesController < ApplicationController
  def index
    @q = EstimateHeader.joins({:estimate_details => :vendor}, :customer)
             .where(is_deleted: false)
             .order(created_at: :desc)
             .select("vendors.vendor_name, customers.customer_name,
estimate_details.*, estimate_headers.*, estimate_headers.id as eh_id")
             .ransack(params[:q])
    @estimates = @q.result(distinct: true)
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

    @estimate_d = EstimateDetail.new

    if @estimate.save
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

    else
      render :new
    end

  end

  def show
    @estimate = EstimateHeader.joins({:estimate_details => :vendor}, :customer)
                    .select("vendors.vendor_name, customers.customer_name,
estimate_details.*, estimate_headers.*, estimate_headers.id as eh_id")
                    .find(params[:id])
  end

  def edit
    estimate = EstimateHeader.joins({:estimate_details => :vendor}, :customer)
                   .select("vendors.vendor_name, customers.customer_name,
estimate_details.*, estimate_headers.*")
                   .find(params[:id])
    estimate.update!(estimate_params)
    redirect_to estimates_url, notice: "見積書NO「#{estimate.estimate_id}」を更新しました。"
  end

  def destroy
    estimate_h = EstimateHeader.find(params[:id])
    estimate_d = EstimateDetail.where(estimate_header_id: params[:estimate_header_id])
    estimate_h.update!(is_deleted: true, deleted_at: DateTime.now)
    estimate_d.destroy_all
    redirect_to estimates_url, notice: "見積書NO「#{estimate_h.estimate_id}」を削除しました。"
  end

  private

  def estimate_params
    params.require(:estimate_header).permit(
        :customer, :customer_person, :estimate_id,
        estimate_d: [:product_name, :detail, :quantity, :kind, :unit_price, :delivery_period, :vendor])
  end

end
