class Admin::EmployeesController < ApplicationController
  def index
    @q = Employee.where(is_deleted: false).order(id: :asc).ransack(params[:q])
    @employees = @q.result(distinct: true)
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to admin_employee_url(@employee), notice: "社員「#{@employee.employee_name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
    @employee = Employee.find(params[:id])

  end

  def update
    @employee = Employee.find(params[:id])

    if @employee.update(employee_params)
      redirect_to admin_employee_url(@employee), notice: "社員「」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.update!(is_deleted: true, deleted_at: DateTime.now)
    redirect_to admin_employee_url, notice: "社員「#{@employee.employee_name}」を削除しました。"
  end

  private

  def employee_params
    params.require(:employee).permit(
        :employee_name, :employee_name_kana, :login_id, :password, :password_confirmation, :admin)
  end
end
