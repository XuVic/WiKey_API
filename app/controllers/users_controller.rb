class UsersController < ApplicationController
  before_action :set_user, only:[:edit, :update, :show]
  before_action :require_same_user, only:[:edit, :update]
  before_action :require_admin, only:[:destroy]
  
  def index 
    @users = User.paginate(page:params[:page], per_page:2)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[user_id] = @user.id
      flash[:success] = "Welcome to Alpha blog #{@user.username}."
      redirect_to articles_path
    else
      render :new
    end
  end
  
  def edit 
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "Update successly."
      redirect_to articles_path
    else
      render :edit
    end
  end
  
  def show
    @user_articles = @user.articles.paginate(page:params[:page], per_page:2)
  end
  
  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
  def set_user
    @user = User.find(params[:id])
  end
  def require_same_user
    if @user != current_user
      flash[:danger] = "You can only edit your account."
      redirect_to root_path
    end
  end
  def require_admin
    if login? and !current_user.admin?
      flash[:danger] = "You don't have permission."
      redirect_to root_path
    end
  end
end