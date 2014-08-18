class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :trips
  belongs_to :group

  before_save :ensure_authentication_token, :ensure_group
 
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  #initialization method that wraps this user in a group
  def ensure_group 
    if self.group == nil
      self.group = Group.create(name: "#{self.email} Group")
    end
  end
end
