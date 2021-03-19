module ReuProgram
  class RecommenderFormsController < AdminController
    before_action :load_form, except: %i[index]

    def index
      @forms = RecommenderForm.order(status: :desc, created_at: :desc)
    end

    def show; end

    def show_schema; end

    def edit; end

    def update
      if @form.update(form_params)
        @form.sections.each do |section|
          section.update_column('count', @form.recommenders_count)
        end
        redirect_to edit_reu_program_recommender_form_path(@form)
      else
        render :edit
      end
    end

    def make_active
      RecommenderForm.transaction do
        RecommenderForm.all.each(&:draft!)
        @form.active!
      end
      redirect_to reu_program_recommender_forms_path
    end

    def duplicate
      @form.duplicate
      redirect_to reu_program_recommender_forms_path
    end

    private

    def form_params
      params.require(:recommender_form)
            .permit(:name, :recommenders_count, :handle_recommendations)
    end

    def load_form
      @form = RecommenderForm.find(params[:id])
    end
  end
end
