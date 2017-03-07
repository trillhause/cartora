class EventInvitationJob < ApplicationJob
  queue_as :high

  MILLIN = "er0reAowoN4:APA91bFXWu1LVRABli_qMk3gK_4JcfZicMuojs1rGRbqAdlISb9j1lxw5gjw2UPIv35tB4A4hxvIuthRx65pWjLqGpUjaDGJlbYJHACLWeNQm-q_tJoiYawUFtvlKXjNoZ2c9vGyJp_O"
  YIFAN = "dJrliMHhmYg:APA91bErqVvFRyLYwbG2LQXCoQKyV81wcIUnj6LLLtrDBLpMk3UWHU2oHUH-MLG2a_HlC8CM0Ur9IORunhSI-FBYUZr-AYSjXDGsf5YRqanSiuhzGicDl18bT6mjFc_cj_gPpVHHfK-a"
  YIFAN_EM = "dsbLRpLyXgM:APA91bFkw7i-EWPgWXavSvaZgU_Gui4LklclXl9Wxqfmu4tfYbchBndwnQad9yWexW-jsDCHt9s68_HygWF7Nwf4mMUvQGwpNYtk0hgtTD2b_BUM9JCUYrGBfNVuGxQA6FMFlSYTeQmk"

  def perform(email, event)
    unless user = User.find_by(email: email)
      user = generate_user(email)
      # send email
    end
    #registration_id = [MILLIN]

    if registration_id = [user.fcm_id]
      options = {data: {score: "Test Notifaction"}, collapse_key: "Cartora successfully sent its first Notification"}
      Traveltime::Application::GCM.send(registration_id, options)
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


