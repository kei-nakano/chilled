class CategoriesController < ApplicationController
  before_action :restrict_user

  def edit
    @category = Category.find_by(id: params[:id])
  end

  def update
    @category = Category.find_by(id: params[:id])
    if @category&.update(category_params)
      flash[:notice] = "更新しました"
      redirect_to "/search?type=category"
    else
      render 'edit'
    end
  end

  def destroy
    @category = Category.find_by(id: params[:id])
    flash[:notice] = if @category&.destroy
                       "削除しました"
                     else
                       "削除に失敗しました"
                     end
    redirect_to "/search?type=category"
  end

  private

  def category_params
    params.require(:category).permit(
      :name, :image
    )
  end
end
