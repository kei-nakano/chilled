class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.image_name = "default_user.jpg"
    if @user.save
      flash[:notice] = "登録しました"
      redirect_to '/users'
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    unless params[:user][:image].nil?
      @user.update(image_name: @user.id.to_s + ".jpg")
      File.binwrite("public/user_images/#{@user.image_name}", params[:user][:image].read)
    end
    if @user.update(user_params)
      flash[:notice] = "更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = "削除しました"
    redirect_to '/users'
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email
    )
  end
end
