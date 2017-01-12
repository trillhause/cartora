class Api::V1::EventsController < ApplicationController
  before_action :authenticate_with_token!

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
    location = event.build_location(location_params)

    if event.save && location.save
      params[:participants].each do |user|
        event.participations.build(user_id: user[:id]).save
      end unless params[:participants].nil?

      render json: event,
             status: :created,
             location: api_user_event_path(current_user, event),
             serializer: EventWithParticipantsSerializer
    else
      render json: { errors: event.errors, location_errors: location.errors},
             status: :unprocessable_entity
    end
  end

  def update
    event = current_user.hosting.find(params[:id])

    event.participations.destroy_all
    params[:participants].each do |user|
      event.participations.build(user_id: user[:id]).save
    end unless params[:participants].nil?

    if params[:location]
      unless event.location.update(location_params)
        render json: { errors: event.location.errors },
               status: :unprocessable_entity
        return
      end
    end

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
    params.permit(:name,:start_time,:end_time)
  end

  def location_params
    params.require(:location).permit(:lat, :lng)
  end
end
