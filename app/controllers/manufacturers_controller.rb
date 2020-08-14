class ManufacturersController < ApplicationController
  before_action :restrict_user

  def edit
    @manufacturer = Manufacturer.find_by(id: params[:id])
  end

  def update
    @manufacturer = Manufacturer.find_by(id: params[:id])
    if @manufacturer&.update(manufacturer_params)
      flash[:notice] = "更新しました"
      redirect_to "/search?type=manufacturer"
    else
      render 'edit'
    end
  end

  def destroy
    @manufacturer = Manufacturer.find_by(id: params[:id])
    flash[:notice] = if @manufacturer&.destroy
                       "削除しました"
                     else
                       "削除に失敗しました"
                     end
    redirect_to "/search?type=manufacturer"
  end

  private

  def manufacturer_params
    params.require(:manufacturer).permit(
      :name, :image
    )
  end
end
