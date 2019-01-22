class Address < ActiveRecord::Base
  attr_accessible :address, :address2, :city, :country, :label, :permanent, :state, :zip
  belongs_to :applicant, :class_name => "Applicant", :foreign_key => "applicant_id"

  validates :address,  :presence => true
  validates :label,  :inclusion => { :in => %w(Home School Other) }
  validates :city,  :presence => true
  validates :state,  :presence => true
  validates :zip,  :presence => true
  validates :permanent,  :inclusion => { :in => ["Yes", "No"] }

  def to_s
    "#{self.address},#{' ' + self.address2 + ',' if self.address2} #{self.city}, #{self.state} #{self.zip}"
  end

  def for_admin
    str = <<-HTML
      <br>
      <b>Label:</b> #{self.label}<br>
      <b>Is this address permanent?</b> #{self.permanent}<br>
      <b>Street Address:</b> #{self.address}<br>
      <b>Apartment:</b> #{self.address2}<br>
      <b>City:</b> #{self.city}<br>
      <b>State:</b> #{self.state}<br>
      <b>Zip:</b> #{self.zip}<br>
    HTML
    str.html_safe
  end
end
