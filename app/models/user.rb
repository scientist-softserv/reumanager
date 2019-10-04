class User < ApplicationRecord
  rolify

  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable,
         :lockable, :confirmable, :registerable # , timeoutable

  attr_accessor :super_admin

  belongs_to :application, dependent: :destroy, optional: true

  after_save do
    self.add_role(:super_admin) if [1, '1', true].include?(self.super_admin)
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
