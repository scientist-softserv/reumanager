class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable, :lockable, :timeoutable

  belongs_to :application, dependent: :destroy, optional: true

  def name
    "#{self.first_name} #{self.last_name}"
  end
end
