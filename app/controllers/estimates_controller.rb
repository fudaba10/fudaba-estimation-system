class EstimatesController < ApplicationController
  def index
    @q = EstimateHeader.includes(:customer)
             .where(is_deleted: false)
             .order(created_at: :desc)
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
    eh_id = EstimateHeader.last
     if eh_id.nil?
       eh_id = '1'
     else
       eh_id = (EstimateHeader.last[:id] +1).to_s
     end
    @estimate.estimate_id =
        @estimate.customer.customer_initial + d.strftime + '−' + eh_id

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
    @estimate = EstimateHeader.includes([{estimate_details: :vendor}, :customer]).find(params[:id])
  end

  def edit
    @estimate = EstimateHeader.includes([{estimate_details: :vendor}, :customer]).find(params[:id])
    # @estimate_h = EstimateHeader.find(params[:id])
    # @estimate_d = EstimateHeader.includes(:estimate_details).where(estimate_header_id: params[:id])
  end

  def update
    estimate = EstimateHeader.find(params[:id])
    eh_param = estimate_params
    estimate.customer = Customer.find(eh_param[:customer].to_i)
    estimate.customer_person = eh_param[:customer_person]

    estimate_d = EstimateDetail.where(estimate_header_id: params[:id])
    ed_param = estimate_params[:estimate_d]
    estimate_d.product_name = ed_param[:product_name]
    estimate_d.detail = ed_param[:detail]
    estimate_d.quantity = ed_param[:quantity].to_i
    estimate_d.kind = ed_param[:kind]
    estimate_d.unit_price = ed_param[:unit_price].to_i
    estimate_d.total_fee = estimate_d.quantity * estimate_d.unit_price
    estimate_d.tax = estimate_d.total_fee * 0.1
    estimate_d.tax_amount = estimate_d.total_fee + estimate_d.tax
    estimate_d.vendor = Vendor.find(ed_param[:vendor].to_i)

    estimate.save
    estimate_d.save
    redirect_to estimates_url, notice: "見積書NO「#{estimate.estimate_id}」を更新しました。"
  end


  def destroy
    estimate = EstimateHeader.find(params[:id])
    estimate.update!(is_deleted: true, deleted_at: DateTime.now)
    #物理削除不要？
    # estimate_d = EstimateDetail.where(estimate_header_id: params[:id])
    # estimate_d.destroy_all
    redirect_to estimates_url, notice: "見積書NO「#{estimate.estimate_id}」を削除しました。"
  end

  private

  def estimate_params
    params.require(:estimate_header).permit(
        :customer, :customer_person, :estimate_id,
        estimate_d: [:product_name, :detail, :quantity, :kind, :unit_price, :delivery_period, :vendor])
  end

end
