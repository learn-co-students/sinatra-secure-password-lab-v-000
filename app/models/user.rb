class User < ActiveRecord::Base

  has_secure_password
  validates :username, presence: true # see http://guides.rubyonrails.org/active_record_validations.html#validations-overview

end
