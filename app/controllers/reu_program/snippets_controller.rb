module ReuProgram
  class SnippetsController < AdminController
    before_action :authenticate_program_admin!, except: %i[index]
    before_action :load_snippet, except: %i[index]

    def index
      @snippets = Snippet.order(:id)
    end

    def edit; end

    def update
      if @snippet.update(snippet_params)
        redirect_to action: "index"
      else
        redirect_to action: "edit"
      end
    end

    private

    def snippet_params
      params.require(@snippet.model_name.singular).permit!
    end

    def load_snippet
      @snippet = Snippet.find(params[:id])
    end
  end
end
