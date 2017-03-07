require 'fcm'

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

  def update_fcm
    if current_user == User.find_by(id: params[:user_id])
      if current_user.update(params.permit(:fcm_id))
        render json: {fcm_id: current_user.fcm_id}, status: :ok
      else
        render json: {errors: current_user.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: "Not authenticated" }, status: :unauthorized
    end
  end

  def send_push
    fcm = FCM.new("AAAAZ3gGsj4:APA91bEpMYJjti5khYaWrhzDmz5SHhu9u_JqZIK7Ua5zK7Z1O1cyVcp9ieYVlmH23vU32oVBr-xNF3eowkb-y-YHaPgnzAxMw0kahnhdAXqIqtDh1L6kla2aFQKE2gjkLKOTT2azeLyI")

    registration_ids= ["dJrliMHhmYg:APA91bErqVvFRyLYwbG2LQXCoQKyV81wcIUnj6LLLtrDBLpMk3UWHU2oHUH-MLG2a_HlC8CM0Ur9IORunhSI-FBYUZr-AYSjXDGsf5YRqanSiuhzGicDl18bT6mjFc_cj_gPpVHHfK-a", "dsbLRpLyXgM:APA91bFkw7i-EWPgWXavSvaZgU_Gui4LklclXl9Wxqfmu4tfYbchBndwnQad9yWexW-jsDCHt9s68_HygWF7Nwf4mMUvQGwpNYtk0hgtTD2b_BUM9JCUYrGBfNVuGxQA6FMFlSYTeQmk","er0reAowoN4:APA91bFXWu1LVRABli_qMk3gK_4JcfZicMuojs1rGRbqAdlISb9j1lxw5gjw2UPIv35tB4A4hxvIuthRx65pWjLqGpUjaDGJlbYJHACLWeNQm-q_tJoiYawUFtvlKXjNoZ2c9vGyJp_O"] # an array of one or more client registration tokens
    options = {data: {score: "Test Notifaction"}, collapse_key: "Cartora successfully sent its first Notification"}
    response = fcm.send(registration_ids, options)
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation, :fcm_id)
  end
end