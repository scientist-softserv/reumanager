class User < ApplicationRecord
  belongs_to :grant, optional: true
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable, :lockable, :timeoutable

  def name
    "#{self.first_name} #{self.last_name}"
  end
end
