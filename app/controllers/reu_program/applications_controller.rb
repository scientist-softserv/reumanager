module ReuProgram
  class ApplicationsController < AdminController
    before_action :load_application, except: %i[index]

    def index
      @applications = Application.all
      @first_name_path = Field.important_field_path('first_name')
      @last_name_path = Field.important_field_path('last_name')
      respond_to do |format|
        format.html
        format.pdf do
          document = ApplicationPdf.new(@applications)
          document.build
          send_data document.render, disposition: "attachment; filename=applications_export.pdf", type: "application/pdf"
        end
        format.csv do
          document = ApplicationCsv.new(@applications)
          send_data document.build, disposition: "attachment;filename=applications_export.csv", type: "text/csv"
        end
      end
    end

    def show
      respond_to do |format|
        format.html
        format.pdf do
          document = ApplicationPdf.new([@Application])
          document.build
          send_data document.render, disposition: "attachment; filename=Application_export.pdf", type: "application/pdf"
        end
        format.csv do
          document = ApplicationCsv.new([@Application])
          send_data document.build, disposition: "attachment;filename=Application_export.csv", type: "text/csv"
        end
      end
    end

    def new
    end

    def create
    end

    def edit
    end

    def update
    end

    def accept
      if @application.state != 'Accepted'
        @application.update(state: 'Accepted')
        redirect_to action: 'index'
      end
    end

    def reject
      if @application.state != 'Rejected'
        @application.update(state: 'Rejected')
        redirect_to action: 'index'
      end
    end

    private

    def load_application
      @application = Application.find(params[:id])
    end

  end
end
