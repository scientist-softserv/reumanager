class Award < ActiveRecord::Base
  attr_accessible :date, :description, :title

  belongs_to :applicant, :class_name => "Applicant", :foreign_key => "applicant_id"

  validates :title, :presence => true

  def to_s
    "#{self.title} - #{self.description}"
  end

  def for_admin
    str = <<-HTML
      <b>Title:</b> #{self.title}<br />
      <b>Date:</b> #{self.date}<br />
      <b>Description:</b> #{self.description}<br />
    HTML
    str.html_safe
  end
end
