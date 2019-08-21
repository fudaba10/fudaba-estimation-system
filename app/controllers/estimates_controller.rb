class EstimatesController < ApplicationController
  def index
  end

  def new
    @estimate_h = EstimateHeader.new
    @estimate_d = EstimateDetail.new
  end

  def create
    @estimate = current_user.estimate_headers.new(params_int(estimate_params))

    if @estimate.save!
      redirect_to estimates_path, notice: "見積「#{@estimate_h.estimate_id}」を登録しました"
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
        estimate_d_attributes: [:product_name, :detail, :quantity, :kind, :unit_price, :delivery_period, :vendor_id])
  end

  def params_int(estimate_params)
    estimate_params.each do |key,value|
      if integer_string?(value)
        estimate_params[key]=value.to_i
      end
    end

  end

end
