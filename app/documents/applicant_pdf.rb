class ApplicantPdf
  
  include Prawn::View
  attr_accessor :applicants, :applicant
  
  def initialize(applicants)
    @applicants = applicants
    font_families.update(
    "fontawesome" => {
    normal: "app/assets/fonts/fontawesome-webfont.ttf",
    bold: "app/assets/fonts/fontawesome-webfont.ttf"
    }
    )
  end
  
  def build
      applicants.each do |applicant|
      @applicant = applicant
      header  
    end
  end
      
 def header
   @applicant.data.each do |key, value|
    if key.match(/_/)
      text "#{key.split('_').map(&:capitalize).join(' ')}", size: 18, inline_format: true, style: :bold
     move_down 1
      value.each do |key, value|
        text "<b>#{key.capitalize}:</b> #{value}", inline_format: true
      end
     move_down 50
     
    else
      text "#{key.capitalize}", size: 18, inline_format: true, style: :bold
      move_down 1
      if value.is_a?(Array)
        value.each do |key, value|
          key.each do |key, value|
            text "<b>#{key.capitalize}:</b> #{value}", inline_format: true
          end
        end
      move_down 6
      else
        value.each do |key, value|
          if key.downcase == "date_of_birth"
            text "<b>#{key.split('_').map(&:capitalize).join(' ')}:</b> #{value.to_date}", inline_format: true
          else
            text "<b>#{key.split('_').map(&:capitalize).join(' ')}:</b> #{value}", inline_format: true
          end
        end
      move_down 6
      end
    end
   end
  end
end