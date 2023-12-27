class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
    @user = User.find(params[:id])
    render json: @user, status: :ok
  end
  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  # def update
  #   unless @user.update(user_params)
  #     render json: { errors: @user.errors.full_messages },
  #            status: :unprocessable_entity
  #   end
  # end

  def destroy
    @user=User.find(params[:id])
    @user.destroy
    render json: { message: 'User successfully deleted' }, status: :ok
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :ok
    else
      render json: { error: @user.errors.messages }, status: :unprocessable_entity
    end
  end

  def login
    @user=User.find(params[:id])
    @user = User.find_by(username: user_params[:username])
    if @user && @user.authenticate(user_params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unprocessable_entity
    end
  end

  
  private
  def user_params
    params.require(:users).permit(:username, :password)
  end
end
