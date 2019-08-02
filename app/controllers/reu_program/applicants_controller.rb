module ReuProgram
  class ApplicantsController < AdminController
    before_action :authenticate_program_admin!, except: %i[index]
    before_action :load_applicant, except: %i[index]
    
    def index
      @applicants = Applicant.all
      respond_to do |format|
        format.html
        format.pdf do
          document = ApplicantPdf.new(@applicants)
          document.build
          send_data document.render, disposition: "attachment; filename=applicants_export.pdf", type: "application/pdf"
        end
        format.csv do
          document = ApplicantCsv.new(@applicants)
          send_data document.build, disposition: "attachment;filename=applicants_export.csv", type: "text/csv"
        end
      end
    end

    def show
      respond_to do |format|
        format.html
        format.pdf do
          document = ApplicantPdf.new([@applicant])
          document.build
          send_data document.render, disposition: "attachment; filename=applicant_export.pdf", type: "application/pdf"   
        end
        format.csv do
          document = ApplicantCsv.new([@applicant])
          send_data document.build, disposition: "attachment;filename=applicant_export.csv", type: "text/csv"
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
      if @applicant.state != 'Accepted'
        @applicant.update(state: 'Accepted')
        redirect_to action: 'index'
      end
    end
    
    def reject
      if @applicant.state != 'Rejected'
        @applicant.update(state: 'Rejected')
        redirect_to action: 'index'
      end
    end
    
    private
    
    def applicant_params
    end
    
    def load_applicant
      @applicant = Applicant.find(params[:id])
    end
    
  end
end
