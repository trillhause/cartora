require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { FactoryGirl.build :event }
  subject { event }

  it { should respond_to :name }
  it { should respond_to :start_time }
  it { should respond_to :end_time }
  it { should respond_to :host_id }

  it { should validate_presence_of :name }
  it { should validate_presence_of :host_id }
  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }
  it { should be_valid }

  it { should belong_to(:host).class_name('User').with_foreign_key('host_id') }

  describe 'when start_time is after end_time' do
    before do
      event.start_time = "2016-11-13 14:39:19"
      event.end_time = "2016-11-13 13:39:19"
    end
    it { should be_invalid }
  end

  describe '#participation association' do
    before do
      event.save
      3.times { FactoryGirl.create :participation, user: FactoryGirl.build(:user), event: event }
    end

    it 'destroys all participation record for event when event is destroyed' do
      participations = event.participations
      event.destroy
      participations.each do |participant|
        byebug
        expect(Participation.find(participant)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end