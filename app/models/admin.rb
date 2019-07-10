class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
	 :confirmable, :trackable, :timeoutable, :lockable

end
