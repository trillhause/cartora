class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  validates :auth_token, uniqueness: true
  validates :first_name, :last_name, presence: true
  before_create :generate_authentication_token!

  has_many :events, through: :participations
  has_many :participations, dependent: :destroy
  has_many :attending, -> { where(attending: true) }, :class_name => 'Participation'
  has_many :invited, -> { where(attending: false) }, :class_name => 'Participation'
  has_many :hosting, class_name: 'Event', foreign_key: :host_id, dependent: :destroy
  has_one :location, as: :area, dependent: :destroy

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end
end
