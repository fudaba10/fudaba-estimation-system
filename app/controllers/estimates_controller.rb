class EstimatesController < ApplicationController
  def index
    @q = EstimateHeader.includes(:customer)
             .where(is_deleted: false)
             .order(created_at: :desc)
             .ransack(params[:q])
    @estimates = @q.result(distinct: true)
  end

  def new
    @estimate = EstimateHeader.new
    @estimate.estimate_details.build
    @estimate_d = EstimateDetail.new
  end

  def create
    d = Date.today
    year = d.strftime("%Y")
    month = d.strftime("%m")
    day = d.strftime("%d")

    @estimate = EstimateHeader.new
    eh_param = estimate_params
    @estimate.employee = current_user
    @estimate.customer = Customer.find(eh_param[:customer_id].to_i)
    @estimate.customer_person = eh_param[:customer_person]
    # TODO Header:id が存在しない場合、1で登録する。
    eh_id = EstimateHeader.last
     if eh_id.nil?
       eh_id = '1'
     else
       eh_id = (EstimateHeader.last[:id] +1)
     end
    @estimate.estimate_id =
        @estimate.customer.customer_initial + year + month + day + '−' + eh_id.to_s
    @estimate.save(validate: false)

    header_is_valid = @estimate.valid?
    flash.now[:alert] = @estimate.errors.full_messages

    all_detail_is_valid = true
    eh_param[:estimate_details_attributes].each do |index, ed_param|
      estimate_d = @estimate.estimate_details.build
      estimate_d.product_name = ed_param[:product_name]
      estimate_d.detail = ed_param[:detail]
      estimate_d.quantity = ed_param[:quantity].to_i
      estimate_d.kind = ed_param[:kind]
      estimate_d.unit_price = ed_param[:unit_price].to_i
      estimate_d.total_fee = ed_param[:total_fee].to_i
      estimate_d.tax = ed_param[:tax].to_i
      estimate_d.tax_amount = ed_param[:tax_amount].to_i
      estimate_d.delivery_period = ed_param[:delivery_period]
      estimate_d.vendor = Vendor.find(ed_param[:vendor_id].to_i)
      estimate_d.estimate_header_id = @estimate.id
      estimate_d.estimate_detail_id = ed_param[:estimate_detail_id].to_i

      estimate_d.save if header_is_valid && all_detail_is_valid
      if ! estimate_d.valid?
        all_detail_is_valid = false
        flash.now[:alert].concat estimate_d.errors.full_messages
      end
    end
    if header_is_valid && all_detail_is_valid
      redirect_to estimates_url, notice: "見積書「#{@estimate.estimate_id}」を登録しました"
    else
      render :new
    end
  end

  def show
    @estimate = EstimateHeader.includes([{estimate_details: :vendor}, :customer]).find(params[:id])
  end

  def edit
    @estimate = EstimateHeader.includes([{estimate_details: :vendor}, :customer]).find(params[:id])
  end

  def update
    @estimate = EstimateHeader.find(params[:id])
    eh_param = estimate_params
    @estimate.customer = Customer.find(eh_param[:customer_id].to_i)
    @estimate.customer_person = eh_param[:customer_person]
    @estimate.save

    header_is_valid = @estimate.valid?
    flash.now[:alert] = @estimate.errors.full_messages

    #編集のたびに全部消してnewする？
    estimate_d = EstimateDetail.where(estimate_header_id: params[:id])
    estimate_d.destroy_all

    all_detail_is_valid = true
    eh_param[:estimate_details_attributes].each do |index, ed_param|
      if ed_param[:_destroy] == 'false'
        estimate_d = @estimate.estimate_details.build
        estimate_d.product_name = ed_param[:product_name]
        estimate_d.detail = ed_param[:detail]
        estimate_d.quantity = ed_param[:quantity].to_i
        estimate_d.kind = ed_param[:kind]
        estimate_d.unit_price = ed_param[:unit_price].to_i
        estimate_d.total_fee = ed_param[:total_fee].to_i
        estimate_d.tax = ed_param[:tax].to_i
        estimate_d.tax_amount = ed_param[:tax_amount].to_i
        estimate_d.delivery_period = ed_param[:delivery_period]
        estimate_d.vendor = Vendor.find(ed_param[:vendor_id].to_i)
        estimate_d.estimate_header_id = @estimate.id
        estimate_d.estimate_detail_id = ed_param[:estimate_detail_id].to_i

        estimate_d.save if header_is_valid && all_detail_is_valid
        if ! estimate_d.valid?
          all_detail_is_valid = false
          flash.now[:alert].concat estimate_d.errors.full_messages
        end
      end
    end

    if header_is_valid && all_detail_is_valid
      redirect_to estimates_url, notice: "見積書「#{@estimate.estimate_id}」を更新しました。"
    else
      render :edit
    end

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
        :customer_id, :customer_person, :estimate_id,
        estimate_details_attributes: [:id, :estimate_detail_id, :product_name, :detail,
                                      :quantity, :kind, :unit_price, :total_fee,
                                      :tax, :tax_amount, :delivery_period,
                                      :vendor_id, :_destroy])
  end

end
