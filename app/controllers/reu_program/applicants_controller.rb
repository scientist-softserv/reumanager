module ReuProgram
  class ApplicantsController < AdminController
    before_action :authenticate_program_admin!, except: %i[index]
    before_action :load_applicant, except: %i[index]
    
    def index
      @applicants = Applicant.all
    end

    def show
        
    end

    def new
    end

    def create
    end

    def edit
    end

    def update
      respond_to do |format|
        format.html
        format.csv { send_data @applicant.to_csv, filename: "applicant-#{Date.today}.csv" }
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
