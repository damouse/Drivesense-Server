class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :trips
  belongs_to :group

  before_save :ensure_authentication_token
 
  #searches through all groups to check if this user is invited to any of them. 
  #if so, sets the :outstanding_invite attribute and saves. Call when invite status changes
  def check_invitation
    invited = false
    Group.all.each do |group|
      if group.invited.include? self
        invited = true
      end
    end

    if self.outstanding_invitation != invited
      self.update_attributes(outstanding_invitation: invited)
    end
  end

  #return the group that owns this user, or false if user is not a member of a group
  def get_owning_group

  end

  #return the group that most recently invited this user
  def get_invited_group

  end

  #returns the group that this user administrates, or false if none existsd
  def get_admin_group

  end

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
