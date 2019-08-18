class VendorsController < ApplicationController
  def index
    @q = Vendor.where(is_deleted: false).order(id: :asc).ransack(params[:q])
    @vendors = @q.result(distinct: true)
  end

  def show
    @vendor = Vendor.find(params[:id])
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      redirect_to @vendor, notice: "仕入先「#{@vendor.vendor_name}」を登録しました"
    else
      render :new
    end
  end

  def edit
    @vendor = Vendor.find(params[:id])
  end

  def update
    vendor = Vendor.find(params[:id])
    vendor.update!(vendor_params)
    redirect_to vendors_url, notice: "仕入先「#{vendor.vendor_name}」を更新しました。"
  end

  def destroy
    vendor = Vendor.find(params[:id])
    vendor.update!(is_deleted: true, deleted_at: DateTime.now)
    redirect_to vendors_url, notice: "仕入先「#{vendor.vendor_name}」を削除しました。"
  end

  private

  def vendor_params
    params.require(:vendor).permit(
        :vendor_name, :vendor_name_kana, :postal_code, :address, :tel, :fax)
  end

end
