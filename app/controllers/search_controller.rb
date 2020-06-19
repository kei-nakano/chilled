class SearchController < ApplicationController
  def show
    @keyword = params[:keyword] || ""
    @keyword == "" ? (@digest = "全件の検索結果") : (@digest = "「#{@keyword}」の検索結果")
    @type = params[:type]

    return @results = Item.search(@keyword) if @type.nil?

    if @type == "review"
      @results = Review.search(@keyword)
      @results = @results.where.not(user_id: block_ids(@current_user))
      respond_to do |format|
        return format.js
      end
    end

    if @type == "category"
      @results = Category.search(@keyword)
      respond_to do |format|
        return format.js
      end
    end

    if @type == "user"
      @results = User.search(@keyword)
      @results = @results.where.not(id: block_ids(@current_user))
      respond_to do |format|
        return format.js
      end
    end

    if @type == "manufacturer"
      @results = Manufacturer.search(@keyword)
      respond_to do |format|
        return format.js
      end
    end

    if @type == "tag"
      @results = ActsAsTaggableOn::Tag.where('name like ?', "%" + @keyword + "%")
      respond_to do |format|
        return format.js
      end
    end

    @results = Item.search(@keyword)
    respond_to do |format|
      return format.js
    end
  end
end
