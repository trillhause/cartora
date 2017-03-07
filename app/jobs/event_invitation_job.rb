class EventInvitationJob < ApplicationJob
  include Authenticable
  queue_as :high

  def perform(email, event)
    unless user = User.find_by(email: email)
      user = generate_user(email)
      # send email
    end
      event.participations.build(user_id: user.id).save
  end

  private

  def generate_user(email)
    password = generate_random_password
    user = User.new(
      first_name: nil,
      last_name: nil,
      email: email,
      password: password,
      password_confirmation: password
    )
    raise "Exception #{user.errors.messages}" unless user.save
    return user
  end
end


