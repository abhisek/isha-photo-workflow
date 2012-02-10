class ShootLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :shoot
end
