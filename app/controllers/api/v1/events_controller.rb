class Api::V1::EventsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update]

  def show
    render json: Event.find(params[:id])
  end

  def create
    event = current_user.hosting.build(event_params)
    if event.save
      render json: event, status: :created, location: [:api, event]
    else
      render json: { errors: event.errors }, status: :unprocessable_entity
    end
  end

  def update
    event = current_user.hosting.find(params[:id])
    if event.update(event_params)
      render json: event, status: :ok, location: [:api, event]
    else
      render json: { errors: event.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    event = current_user.hosting.find(params[:id])
    event.destroy
    head :no_content
  end

  private

  def event_params
    params.require(:event).permit(:name,:start_time,:end_time)
  end
end
