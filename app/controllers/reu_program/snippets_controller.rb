module ReuProgram
  class SnippetsController < AdminController
    before_action :authenticate_program_admin!, except: %i[index]
    before_action :load_snippet, except: %i[index]
    
    def index
      @snippets = Snippet.all
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
      @snippet.update_attributes(snippet_params)
    end

    def update_attributes
      @snippet.assign_attributes(snippet_params)
      render partial: 'edit_form', layout: false
    end

    def destroy
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
