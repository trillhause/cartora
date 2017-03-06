class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json

  def show
    respond_with User.find(params[:id]), serializer: UserPublicSerializer
  end

  def create
    user = User.new(user_params)
    if user.save
      sign_in user, store: false
      render json: user, status: :created, location: [:api, user]
    else
      render json: {errors: user.errors }, status: :unprocessable_entity
    end
  end

  def update
    if current_user == User.find_by(id: params[:id])
      if current_user.update(user_params)
        render json: current_user, status: :ok, location: [:api, current_user]
      else
        render json: {errors: current_user.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: "Not authenticated" }, status: :unauthorized
    end
  end

  def destroy
    if current_user == User.find_by(id: params[:id])
      current_user.destroy
      head :no_content
    else
      render json: { errors: "Not authenticated" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation, :fcm_id)
  end
end