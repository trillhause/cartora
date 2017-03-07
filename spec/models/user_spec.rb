require 'rails_helper'

RSpec.describe User, type: :model do

  before { @user = FactoryGirl.build(:user) }
  subject { @user }

  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :auth_token }
  it { should respond_to :first_name }
  it { should respond_to :last_name }

  it { should be_valid }
  it { should validate_uniqueness_of :auth_token }

  it { should have_one(:location) }
  it { should have_many(:hosting) }

  describe 'when email is not present' do
    before { @user.email = " " }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_confirmation_of(:password) }
    it { should allow_value('example@domain.com').for(:email) }
  end

  describe '#generate_authentication_token!' do
    it 'generates a unique token' do
      allow(Devise).to receive(:friendly_token).and_return('auniquetoken123')
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql 'auniquetoken123'
    end

    it 'generates another token when one already has been taken' do
      existing_user = FactoryGirl.create(:user, auth_token: 'anuniquetoken123')
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end

  describe '#hosting association' do
    before do
      @user.save
      3.times { FactoryGirl.create :event, host: @user }
    end

    it 'destroys all events hosted by the user when user is destroyed' do
      hosting = @user.hosting
      @user.destroy
      hosting.each do |event|
        expect(Event.find(event)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe '#participation association' do
    before do
      @user.save
      3.times { FactoryGirl.create :participation, user: @user, event: FactoryGirl.build(:event) }
    end

    it 'destroys all participation record of user when user is destroyed' do
      participations = @user.participations
      @user.destroy
      participations.each do |participant|
        byebug
        expect(Participation.find(participant)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end