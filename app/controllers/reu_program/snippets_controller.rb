module ReuProgram
  class SnippetsController < AdminController
    before_action :authenticate_program_admin!, except: %i[index]
    before_action :load_snippet, except: %i[index]

    def index
      @snippets = Snippet.all
    end

    def edit; end

    def update
      @snippet.update(snippet_params)
      redirect_to action: "index"
    end

    private

    def snippet_params
      params.require(:snippet).permit(:name, :description, :value)
    end

    def load_snippet
      @snippet = Snippet.find(params[:id])
    end
  end
end
