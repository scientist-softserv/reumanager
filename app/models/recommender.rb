class Recommender < ActiveRecord::Base
  attr_accessible :department, :email, :first_name, :last_name, :organization, :phone, :title, :url, :id,
                  :address, :city, :state, :zip, :country

  has_many :recommendations, :dependent => :destroy
  has_many :applicants, :through => :recommendations

  validates :first_name,  :presence => true
  validates :last_name,   :presence => true
  validates :email,   :presence => true
  validates :organization,   :presence => true
  validates :department,   :presence => true
  validates :title,   :presence => true

  validates_uniqueness_of :email, :message => "must be unique"

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def to_s
    recommendations = self.recommendations.map do |r|
      next if r.received_at.blank?
      <<-HTML
        <b>Aplicant Known For:</b> #{r.known_applicant_for}<br />
        <b>Known Capacity:</b> #{r.known_capacity}<br />
        <b>Overall Promise:</b> #{r.overall_promise}<br />
        <b>Undergraduate Institution:</b> #{r.undergraduate_institution}<br />
        <b>Received_at:</b> #{r.received_at.try(:strftime, '%m/%d/%Y')}<br />
        <b>Body:</b> #{r.body}<br />
      HTML
    end
    str = <<-HTML
      <b>First Name:</b> #{self.first_name}<br />
      <b>Last Name:</b> #{self.last_name}<br />
      <b>Title:</b> #{self.title}<br />
      <b>Department:</b> #{self.department}<br />
      <b>Organization:</b> #{self.organization}<br />
      <b>URL:</b> #{self.url}<br />
      <b>Email:</b> #{self.email}<br />
      <b>Phone:</b> #{self.phone}<br />
      <b>Address:</b> #{self.address}<br />
      <b>City:</b> #{self.city}<br />
      <b>State:</b> #{self.state}<br />
      <b>Zip:</b> #{self.state}<br />
      <b>Country:</b> #{self.country}<br />
      <hr>
      #{recommendations.present? ? "<h4>Recommendation from #{self.name}</h4><br>" : ''}
      #{recommendations.present? ? recommendations.join("<hr>\n") : ''}
    HTML
    str.html_safe
  end

  private

  # parse params for existing recommenders and add to array. returns
  # array of existing recommender object and hash with existing
  # recommender attributes removed.
  def self.remove_exisitng_recommenders_from_params(recommenders_attributes)
    existing_recommenders = find_existing_recommenders(recommenders_attributes)

    recommenders_attributes.map do |r|
      # if the existing recommender is included in the attributes hash
      if existing_recommenders.map(&:email).include?(r[1]['email'])
        # remove the attributes for that recommender unless they include the destroy flag
      # debugger
        recommenders_attributes.delete(r[0]) unless r[1]["_destroy"] == '1'
      end
    end

    [existing_recommenders, recommenders_attributes]
  end

  # parse params and lookup recommenders by email. if they exist, add
  # them to an array.
  def self.find_existing_recommenders(recommenders_attributes)
    existing_recommenders = []

    recommenders_attributes.each do |recommenders_attribute|
      recommender = Recommender.find_by_email(recommenders_attribute[1]['email'])
      existing_recommenders << recommender if recommender != nil
    end

    existing_recommenders
  end

end
