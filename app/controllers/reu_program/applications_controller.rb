module ReuProgram
  class ApplicationsController < AdminController
    before_action :load_application, except: %i[index nuke_them_all]

    def index
      @applications = if params[:show_deleted] && current_user.notch8?
                        Application.discarded
                      else
                        Application.kept
                      end

      @applications = @applications.search(params[:search]) if params[:search].present?
      @applications = @applications.where(state: params[:state]) if params[:state].present?

      respond_to do |format|
        format.html do
          @application_count = @applications.count
          @applications = @applications.page(params[:page]).per(15)
        end
        format.pdf do
          document = ApplicationPdf.new(@applications)
          document.build
          send_data document.render, disposition: 'attachment; filename=applications_export.pdf', type: 'application/pdf'
        end
        format.csv do
          document = ApplicationCsv.new(@applications)
          send_data document.build, disposition: 'attachment;filename=applications_export.csv', type: 'text/csv'
        end
      end
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

    def change_state
      @application.update_column(:state, params['application']['state'])
      redirect_to reu_program_applications_path
    end

    def destroy
      @application.discard
      redirect_to reu_program_applications_path
    end

    def restore
      @application.undiscard
      redirect_to reu_program_applications_path
    end

    def nuke_them_all
      Application.destroy_all
      redirect_to reu_program_applications_path
    end

    private

    def load_application
      @application = Application.find(params[:id])
    end
  end
end
