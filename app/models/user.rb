class User < ActiveRecord::Base
  has_many :orders

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #Check user role.Throws an exception when role is not valid
  def getRole (user)
    case user.role
      when 0
        return 'user'
      when 1
        return 'operator'
      when 2
        return 'cto_user'
      when 3
        return 'owner'
      when 4
        return 'anonymous'
       else
        raise ('invalid user' + user.role)
     end
  end

  # def initialize(user)
  #   user ||= User.new(null) # guest user (not logged in)
  #   #Operator and Cto owner can manage all
  #   can :read, :all
  #   if (user.role==1 || user.role==3)
  #     can :manage, :all
  #   end
  #
  #
  #   #Set proper filtering for cto user.TODO deny destroy properties
  #   if (user.role==2)
  #     can [:update,:read], Cto, Order, :user_id => user.id
  #     can [:update,:read], Service, Schedule, :user_id => user.cto_id
  #  end
  #  end
  end

