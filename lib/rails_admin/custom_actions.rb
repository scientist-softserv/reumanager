module RailsAdmin
  module Config
    module Actions
      # common config for custom actions
      class Customaction < RailsAdmin::Config::Actions::Base
        register_instance_option :collection do  #	this is for specific record
          true
        end
        register_instance_option :pjax? do
          false
        end
        register_instance_option :visible? do
          authorized? 		# This ensures the action only shows up for the right class
        end
      end
      class GeneratePDF < Customaction
        RailsAdmin::Config::Actions.register(self)
        # register_instance_option :only do
        #   # model name here
        # end
        register_instance_option :link_icon do
          'fa fa-file-pdf-o' # use any of font-awesome icons
        end
        register_instance_option :http_methods do
          [:get]
        end
        register_instance_option :controller do
          Proc.new do
            applicants = @abstract_model.all
            document = ApplicantsDocument.new(applicants)
            document.build
            send_data document.render, disposition: "attachment; filename=applicants_export.pdf", type: "application/pdf"
          end
        end
      end
    end
  end
end
