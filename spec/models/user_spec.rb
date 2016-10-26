require 'rails_helper'
require 'shoulda-matchers'

RSpec.describe User, type: :model do

  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe "when email is not present" do
    before { @user.email = " " }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_confirmation_of(:password) }
    it { should allow_value('example@domain.com').for(:email) }
  end

end