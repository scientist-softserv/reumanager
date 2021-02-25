module ReuProgram
  class ApplicationsController < AdminController
    before_action :load_application, except: %i[index]

    def index
      @applications = if params[:state]
                        Application.where(state: params[:state]).page(params[:page]).per(15)
                      else
                        Application.page(params[:page]).per(15)
                      end
                      if params[:search]
                        @applications = @applications.where("CONCAT(data -> 'profile' ->> 'first_name', ' ', data -> 'profile' ->> 'last_name', ' ', data -> 'profile' ->> 'contact_email') LIKE ?", "%#{params[:search]}%")
                      end      
      respond_to do |format|
        format.html
        format.pdf do
          document = ApplicationPdf.new(all_applications)
          document.build
          send_data document.render, disposition: 'attachment; filename=applications_export.pdf', type: 'application/pdf'
        end
        format.csv do
          document = ApplicationCsv.new(all_applications)
          send_data document.build, disposition: 'attachment;filename=applications_export.csv', type: 'text/csv'
        end
      end
      @sum = Application.count
      @count = Application.group('state').count
    end

    def show
      respond_to do |format|
        format.html
        format.pdf do
          document = ApplicationPdf.new([@application])
          document.build
          send_data document.render, disposition: 'attachment; filename=Application_export.pdf', type: 'application/pdf'
        end
        format.csv do
          document = ApplicationCsv.new([@application])
          send_data document.build, disposition: 'attachment;filename=Application_export.csv', type: 'text/csv'
        end
      end
    end

    def accept
      @application.update(state: 'accepted')
      redirect_to reu_program_applications_path
    end

    def reject
      @application.update(state: 'rejected')
      redirect_to reu_program_applications_path
    end

    private

    def load_application
      @application = Application.find(params[:id])
    end

    def all_applications
      if params[:state]
        Application.where(state: params[:state])
      else
        Application.all
      end
    end
  end
end
