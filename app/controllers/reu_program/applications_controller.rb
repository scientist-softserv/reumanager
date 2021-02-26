module ReuProgram
  class ApplicationsController < AdminController
    before_action :load_application, except: %i[index]

    def index
      @applications = if params[:search].present?
                        Application.search(params[:search])
                      else
                        Application
                      end
      @applications = @applications.where(state: params[:state]) if params[:state].present?

      respond_to do |format|
        format.html do
          @applications = @applications.page(params[:page]).per(15)
          @application_count = @applications.count
        end
        format.pdf do
          document = ApplicationPdf.new(@application)
          document.build
          send_data document.render, disposition: 'attachment; filename=applications_export.pdf', type: 'application/pdf'
        end
        format.csv do
          document = ApplicationCsv.new(@application)
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
  end
end
