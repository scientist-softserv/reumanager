module ReuProgram
  class ApplicantsController < AdminController
    before_action :authenticate_program_admin!, except: %i[index]
    before_action :load_applicant, except: %i[index]
    
    def index
      @applicants = Applicant.all
      
      respond_to do |format|
        format.html
        format.csv do
          document = ApplicantCsv.new(@applicants)
          send_data document.build, disposition: "attachment;filename=applicants_export.csv", type: "text/csv"
        end
      end
    end

    def show
      respond_to do |format|
        format.html
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
    
    private
    
    def applicant_params
    end
    
    def load_applicant
      @applicant = Applicant.find(params[:id])
    end
    
  end
end
