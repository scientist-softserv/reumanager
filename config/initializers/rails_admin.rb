# RailsAdmin config file. Generated on September 22, 2012 18:58
# See github.com/sferik/rails_admin for more informations
require Rails.root.join('lib', 'admin_accept')
require Rails.root.join('lib', 'admin_reject')

RailsAdmin.config do |config|
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  config.audit_with :history, Applicant
  config.audit_with :history, User

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['Reuman', 'Admin']

  config.default_items_per_page = 50

  config.actions do
    # root actions
    dashboard                     # mandatory
    # collection actions
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
    # member actions
    show
    edit
    delete
    history_show
    show_in_app
    accept do
      visible do
        ["Applicant", "Applied", "Submitted", "Complete", "MissedDeadline", "Withdrawn", "Rejected", "Accepted"].include?(bindings[:abstract_model].model.to_s)
      end
    end
    reject do
      visible do
        ["Applicant", "Applied", "Submitted", "Complete", "MissedDeadline", "Withdrawn", "Rejected", "Accepted"].include?(bindings[:abstract_model].model.to_s)
      end
    end
  end

  applicant_config = lambda {
    list do

      field :name do
        searchable :last_name
        sortable :last_name
        filterable false
      end

      field :first_name do
        searchable true
        filterable false
        visible false
      end

      field :last_name do
        searchable true
        filterable true
        visible false
      end

      field :academic_info do
        formatted_value do
          bindings[:object].academic_record(bindings[:object].record)
        end
      end

      field :current_status do
        searchable :state
        sortable :state
        filterable :state
        visible false
      end
      field :created_at do
        label "Started on"
        date_format :short
      end
    end

    show do
      field :personal_info do
        label "Personal Information and Research Interest"
        formatted_value do
          applicant = bindings[:object]
            "<b>Name:</b> #{applicant.name if applicant.name}<br />
            <b>Email:</b> #{applicant.email if applicant.email}<br />
            <b>Phone:</b> #{applicant.phone if applicant.phone}<br />
            <b>Cell Phone:</b> #{applicant.cell_phone if applicant.cell_phone}<br />
            <b>DOB:</b>  #{applicant.dob if applicant.dob}<br />
            <b>Gender:</b>  #{applicant.gender if applicant.gender}<br />
            <b>LGBT Community:</b>  #{applicant.member_of_lgbt_community if applicant.member_of_lgbt_community}<br />
            <b>Ethnicity:</b>  #{applicant.ethnicity if applicant.ethnicity}<br />
            <b>Race:</b>  #{applicant.race if applicant.race}<br />
            <b>Father's Highest Education:</b>  #{applicant.fathers_highest_education if applicant.fathers_highest_education}<br />
            <b>Mother's Highest Education:</b>  #{applicant.mothers_highest_education if applicant.mothers_highest_education}<br />
            <b>Disability:</b>  #{applicant.disability if applicant.disability}<br />
            <b>Citizenship:</b>  #{applicant.citizenship if applicant.citizenship}<br />
            <b>Green Card:</b>  #{applicant.green_card_holder if applicant.green_card_holder}<br />
            <b>Military:</b>  #{applicant.military if applicant.military}<br />
            <b>Veteran Info:</b>  #{applicant.veteran_information if applicant.veteran_information}<br />
            <h4>Personal Statement</h4>
            #{Markdown.render applicant.statement if applicant.statement}
            <h4>How did you hear about us?</h4>
            #{Markdown.render applicant.found_us if applicant.found_us}
            <h4>Research Interest:</h4>
            <b>Research Interest 1:</b> #{applicant.interest.research_interest_1}<br />
            <b>Research Interest 2:</b> #{applicant.interest.research_interest_2}<br />
            <b>Research Interest 3:</b> #{applicant.interest.research_interest_3}<br />
            <h4>Skills and Experience:</h4>
            <b>CPU Skills:</b> #{applicant.interest.cpu_skills}<br />
            <b>Research Experience:</b> #{applicant.interest.research_experience}<br />
            <b>Leadership Experience:</b> #{applicant.interest.leadership_experience}<br />
            <b>Programming Experience:</b> #{applicant.interest.programming_experience}<br />".html_safe
        end
      end

      field :address do
        label "Address"
        formatted_value do
          applicant = bindings[:object]
          applicant.addresses.map do |address|
            "<b>Label:</b> #{address.label}<br />
            <b>Is this address permanent?</b> #{address.permanent}<br />
            <b>Street Address:</b> #{address.address}<br />
            <b>Apartment:</b> #{address.address2}<br />
            <b>City:</b> #{address.city}<br />
            <b>State:</b> #{address.state}<br />
            <b>Zip:</b> #{address.zip}<br />"
          end.join('</br>').html_safe
        end
      end

      field :academic_info do
        label "Acedemic Information"
        formatted_value do
          applicant = bindings[:object]
          academic_information = applicant.records.map do |record|
            "<b>University:</b> #{record.university}<br />
            <b>Start:</b> #{record.start}<br />
            <b>Finish:</b> #{record.finish}<br />
            <b>Major:</b> #{record.major}<br />
            <b>Minor:</b> #{record.minor}<br />
            <b>GPA:</b> #{record.gpa} out of #{record.gpa_range}<br />"
          end.join('<br />')
          academic_information += "<br /><b>GPA Comments:</b> #{Markdown.render applicant.gpa_comment}"

          academic_information += applicant.awards.map do |award|
            "<b>Title:</b> #{award.title}<br />
            <b>Date:</b> #{award.date}<br />
            <b>Description:</b> #{award.description}<br />"
          end.join('<br />')
          academic_information.html_safe
        end
      end

      field :recommender do
        label "Recommenders"
        formatted_value do
          applicant = bindings[:object]
          applicant.recommenders.map do |recommender|
  	        "<b>First Name:</b> #{recommender.first_name}<br />
            <b>Last Name:</b> #{recommender.last_name}<br />
            <b>Title:</b> #{recommender.title}<br />
            <b>Department:</b> #{recommender.department}<br />
            <b>Organization:</b> #{recommender.organization}<br />
            <b>URL:</b> #{recommender.url}<br />
            <b>Email:</b> #{recommender.email}<br />
            <b>Phone:</b> #{recommender.phone}<br />
            <b>Address:</b> #{recommender.address}<br />
            <b>City:</b> #{recommender.city}<br />
            <b>State:</b> #{recommender.state}<br />
            <b>Zip:</b> #{recommender.state}<br />
            <b>Country:</b> #{recommender.country}<br />"
          end.join('</br>').html_safe
        end
      end
    end

    edit do
      field :state, :enum do
        label "Current Status"
        enum do
          ['applied', 'completed_personal_info', 'completed_academic_info', 'completed_recommender_info', 'incomplete', 'submitted', 'complete', 'withdrawn', 'rejected', 'accepted']
        end
      end
      field :first_name
      field :last_name
      field :email
    end
  }

  config.model Applicant do
    weight 0
    instance_exec(&applicant_config)
  end

  config.model Applied do
    label_plural 'Applied'
    weight 1
    instance_exec(&applicant_config)
  end

  config.model Submitted do
    label_plural 'Submitted (Awaiting Recommendations)'
    weight 2
    instance_exec(&applicant_config)
  end

  config.model Complete do
    label_plural 'Complete (with Recommendations) / Awaiting Review'
    weight 3
    instance_exec(&applicant_config)
  end

  config.model Rejected do
    label_plural "Rejected"
    weight 6
    instance_exec(&applicant_config)
  end

  config.model Accepted do
    label_plural 'Accepted'
    weight 7
    instance_exec(&applicant_config)
  end

  config.model Address do
    visible false
  end

  config.model Interest do
    visible false
  end

  config.model AcademicRecord do
    def custom_label_method
      "#{self.degree}, #{self.university}"
    end

    visible false
  end

  config.model Recommender do
     visible false
  end

  config.model Award do
    visible false
  end

  config.model Recommendation do
    visible false
    edit do
      field :known_applicant_for
      field :known_capacity
      field :overall_promise
      field :undergraduate_institution
      field :body
      field :recommender
    end
  end

  config.model Setting do
    edit do
      field :display_name
      field :name
      field :description
      field :value
    end
    list do
      field :display_name
      field :description
      field :value
    end
    show do
      field :name
      field :description
      field :value
    end
  end
  config.model Snippet do
    edit do
      field :display_name
      field :name
      field :description
      field :value, :rich_editor do
        config({
          :insert_many => true
        })
      end
    end
    list do
      field :display_name
      field :description
      field :value do
        formatted_value do
          bindings[:view].strip_tags value.truncate(255)
        end
      end
    end
  end

  config.model User do
    visible false
    #     configure :id, :integer
    #     configure :email, :string
    #     configure :password, :password         # Hidden
    #     configure :password_confirmation, :password         # Hidden
    #     configure :reset_password_token, :string         # Hidden
    #     configure :reset_password_sent_at, :datetime
    #     configure :remember_created_at, :datetime
    #     configure :sign_in_count, :integer
    #     configure :current_sign_in_at, :datetime
    #     configure :last_sign_in_at, :datetime
    #     configure :current_sign_in_ip, :string
    #     configure :last_sign_in_ip, :string
    #     configure :failed_attempts, :integer
    #     configure :unlock_token, :string
    #     configure :locked_at, :datetime
    #     configure :authentication_token, :string
    #     configure :created_at, :datetime
    #     configure :updated_at, :datetime   #   # Sections:
    #   list do; end
    #   export do; end
    #   show do; end
    #   edit do; end
    #   create do; end
    #   update do; end
  end
end
