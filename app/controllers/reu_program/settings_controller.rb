module ReuProgram
  class SettingsController < AdminController
    before_action :load_setting, except: %i[index]

    def index
      @settings = Setting.order(:id)
    end

    def edit
      render :edit_modal, layout: false
    end

    def update
      if @setting.update(setting_params)
        redirect_to action: 'index'
      else
        render :edit
      end
    end

    private

    def setting_params
      params.require(:setting).permit(:name, :description, :value, :time_zone)
    end

    def load_setting
      @setting = Setting.find(params[:id])
    end
  end
end
