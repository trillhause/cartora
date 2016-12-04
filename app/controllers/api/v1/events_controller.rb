class Api::V1::EventsController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :index, :create, :update, :destroy]

  def show
    render json: Event.find(params[:id]),
           serializer: EventWithParticipantsSerializer,
           status: :ok
  end

  def index
    render json: current_user.hosting | current_user.events,
           status: :ok
  end

  def hosting
    render json: current_user.hosting,
           status: :ok
  end

  def attending
    render json: current_user.attending,
           status: :ok
  end

  def invited
    render json: current_user.invited,
           status: :ok
  end

  def create
    event = current_user.hosting.build(event_params)
    if event.save

      params[:event][:participants].each do |user|
        event.participations.build(user_id: user[:id]).save
      end unless params[:event][:participants].nil?

      render json: event,
             status: :created,
             location: api_user_event_path(current_user, event),
             serializer: EventWithParticipantsSerializer
    else
      render json: { errors: event.errors },
             status: :unprocessable_entity
    end
  end

  def update
    event = current_user.hosting.find(params[:id])

    event.participations.destroy_all
    params[:event][:participants].each do |user|
      event.participations.build(user_id: user[:id]).save
    end unless params[:event][:participants].nil?

    if event.update(event_params)
      render json: event,
             status: :ok,
             location: api_user_event_path(current_user, event),
             serializer: EventWithParticipantsSerializer
    else
      render json: { errors: event.errors },
             status: :unprocessable_entity
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
