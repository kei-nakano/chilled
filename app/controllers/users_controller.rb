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
    @user = User.new
    if @user.update(name: params[:user][:name], email: params[:user][:email])
      redirect_to '/users'
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    # if @user.update_attributes(user_params)
    if @user.update(name: params[:user][:name], email: params[:user][:email])
      flash[:notice] = "更新しました"
      # redirect_to @user
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = "削除しました"
    redirect_to '/users'
  end
end
