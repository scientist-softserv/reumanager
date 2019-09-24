module ReuProgram
  class ProgramAdminsController < AdminController
    before_action :load_admin, except: %i[index new create]

    def index
      @admins = User.with_role(:admin).order(:created_at)
    end

    def new
      @admin = User.new
    end

    def create
      @admin = User.new(admin_params)
      if @admin.save
        # add role - persisted user. if save successful and user exists, assign role of admin. rolify can't assign a role to something that doesn't exist yet.
        @admin.add_role :admin
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
      @admin = User.find(params[:id])
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
