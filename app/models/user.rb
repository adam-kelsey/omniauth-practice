class User < ActiveRecord::Base
  has_many :authentications
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:linkedin]

  def self.create_with_omniauth(auth)
    where(email: auth['info']['email']).first_or_create do |user|
      # user.provider = auth["provider"]
      # user.uid = auth["uid"]
      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.password = Devise.friendly_token[0,20]
    end
  end
end
