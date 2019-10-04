module ReuProgram
  class SnippetsController < AdminController
    before_action :load_snippet, except: %i[index]

    def index
      @snippets = Snippet.order(:id)
    end

    def edit
      render layout: false
    end

    def update
      if @snippet.update(snippet_params)
        redirect_to reu_program_snippets_path
      else
        redirect_to edit_reu_program_snippet_path(@snippet)
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
