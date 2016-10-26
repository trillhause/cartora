require 'rails_helper'
require 'api_constraints'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) { request.headers['Accept'] = "application/vnd.traveltime.v1"}

  describe "GET #show" do
    before(:each) do
        @user = FactoryGirl.create :user
        get :show, params: {id: @user.id}, format: :json
      end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it "respond is successful" do
      expect(response.status).to eql 200
    end
  end
end