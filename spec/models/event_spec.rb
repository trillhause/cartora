require 'rails_helper'

RSpec.describe Event, type: :model do

  let(:event) { FactoryGirl.build :event }
  subject { event }

  it { should respond_to :name}
  it { should respond_to :start_time}
  it { should respond_to :end_time}
  it { should respond_to :organiser_id}

  it { should validate_presence_of :name }
  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }

  it  { should be_valid}

  describe 'when start_time is after end_time' do
    before do
      event.start_time = "2016-11-13 14:39:19"
      event.end_time = "2016-11-13 13:39:19"
    end
    it { should be_invalid }
  end
end