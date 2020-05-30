class SearchController < ApplicationController
  def show
    @keyword = params[:keyword] || ""
    @type = params[:type] || "item"
    @results = Review.search(@keyword) if @type == "review"
    @results = Category.search(@keyword) if @type == "category"
    @results = Manuacturer.search(@keyword) if @type == "manufacturer"
    @results = User.search(@keyword) if @type == "user"
    @results = ActsAsTaggableOn::Tag.where('name like ?', @keyword) if @type == "tag"
    @results = Item.search(@keyword) if @type == "item"
    respond_to do |format|
      format.html
      format.js
    end
  end
end
