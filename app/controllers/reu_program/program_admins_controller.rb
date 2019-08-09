module ReuProgram
  class ProgramAdminsController < AdminController
    before_action :load_admin, except: %i[index new create]

    def index
      @admins = ProgramAdmin.order(:created_at)
    end

    def new
      @admin = ProgramAdmin.new
    end

    def create
      @admin = ProgramAdmin.new(admin_params)
      if @admin.save
        redirect_to action: :index
      else
        render :new
      end
    end

    def edit; end

    def update
      if @admin.update(admin_params)
        redirect_to action: :index
      else
        render :edit
      end
    end

    def lock
      @admin.lock_access!
      redirect_to action: 'index'
    end

    def unlock
      @admin.unlock_access!
      redirect_to action: 'index'
    end

    private

    def load_admin
      @admin = ProgramAdmin.find(params[:id])
    end

    def admin_params
      params.require(:program_admin)
            .permit(
              :first_name,
              :last_name,
              :email,
              :password,
              :password_confirmation
            )
    end
  end
end
