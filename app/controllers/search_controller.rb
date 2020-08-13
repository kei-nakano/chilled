class SearchController < ApplicationController
  after_action :respond, only: %i[show]

  def show
    @keyword = params[:keyword] || ""
    @keyword == "" ? (@digest = "全件の検索結果") : (@digest = "「#{@keyword}」の検索結果")
    @type = params[:type] || "item" # typeの指定がない場合、itemタブを優先表示するようにする

    # typeの分岐によらず、検索結果の件数を表示する必要があるため、ifより前に記述
    @items = Item.search(@keyword)
    @reviews = Review.search(@keyword).where.not(user_id: @current_user&.block_ids)
    @categories = Category.search(@keyword)
    @manufacturers = Manufacturer.search(@keyword)
    @users = User.search(@keyword).where(admin: false) # ブロックされていても、検索結果には表示する。twitterと同じ動作とした
    @tags = ActsAsTaggableOn::Tag.where('name like ?', "%" + @keyword + "%")

    return (@results = @items) if @type == "item"
    return (@results = @reviews) if @type == "review"
    return (@results = @categories) if @type == "category"
    return (@results = @manufacturers) if @type == "manufacturer"
    return (@results = @users) if @type == "user"
    return redirect_to "/" unless @type == "tag"

    @results = @tags
  end

  private

  def respond
    respond_to do |format|
      format.js
      format.html
    end
  end
end
