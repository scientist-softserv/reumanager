module ReuProgram
  class SettingsController < AdminController
    before_action :authenticate_program_admin!, except: %i[index]
    before_action :load_setting, except: %i[index]
    
    def index
      @settings = Setting.all
    end
    
    def new; end
    
    def create; end
    
    def edit; end

    def update
      if @setting.update(setting_params)
        redirect_to action: 'index'
      else
        render action: 'edit'
      end
    end
    
    private
    
    def setting_params
      params.require(:setting).permit(:name, :description, :value)
    end
    
    def load_setting
      @setting = Setting.find(params[:id])
    end
  end
end
