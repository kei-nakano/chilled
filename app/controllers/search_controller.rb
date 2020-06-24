class SearchController < ApplicationController
  def show
    @keyword = params[:keyword] || ""
    @keyword == "" ? (@digest = "全件の検索結果") : (@digest = "「#{@keyword}」の検索結果")
    @type = params[:type] || "item" # typeの指定がない場合、itemタブを優先表示するようにする

    @items = Item.search(@keyword)
    @reviews = Review.search(@keyword).where.not(user_id: block_ids(@current_user))
    @categories = Category.search(@keyword)
    @manufacturers = Manufacturer.search(@keyword)
    @users = User.search(@keyword)
    @tags = ActsAsTaggableOn::Tag.where('name like ?', "%" + @keyword + "%")

    if @type == "item"
      @results = @items
      respond_to do |format|
        format.js
        format.html
      end
      return
    end

    if @type == "review"
      @results = @reviews
      respond_to do |format|
        format.js
      end
    end

    if @type == "category"
      @results = @categories
      respond_to do |format|
        return format.js
      end
    end

    if @type == "user"
      @results = @users
      respond_to do |format|
        format.js
        format.html
      end
      return
    end

    if @type == "manufacturer"
      @results = @manufacturers
      respond_to do |format|
        return format.js
      end
    end

    return unless @type == "tag"

    @results = @tags
    respond_to do |format|
      return format.js
    end
  end
end
