class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :trips
  belongs_to :group

  #each of the second attribute returns the groups this user is an admin over, a member over, or is invited to
  has_many :group_admins
  has_many :group_admin, through: :group_admins, source: :group

  has_many :group_memberships
  has_many :group_member, through: :group_memberships, source: :group

  has_many :group_invites
  has_many :group_invite, through: :group_invites, source: :group

  before_save :ensure_authentication_token

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
end
