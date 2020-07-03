class TagsController < ApplicationController
  def destroy
    @tag = ActsAsTaggableOn::Tag.find_by(id: params[:id])
    flash[:notice] = if @tag&.destroy
                       "削除しました"
                     else
                       "削除に失敗しました"
                     end
    redirect_to "/search?type=tag"
  end
end
