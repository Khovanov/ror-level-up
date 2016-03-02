class User < ActiveRecord::Base
  include Omniauthable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  def self.send_daily_digest
    find_each.each do |user|
      # DailyMailer.delay.digest(user)
      # DailyMailer.digest(user).deliver_now
      DailyMailer.digest(user).deliver_later
    end
  end
end
