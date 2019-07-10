module ReuProgram
  class SnippetsController < AdminController
    
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
      @snippet = current_program_admin.snippets.find(params[:id])
    end

    def update
      if @snippet.update(snippet_params)
        redirect_to @snippet, notice: 'Snippet was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
    end
    
    private
    
    def snippet_params
      params.require(:snippet).permit(:name, :description, :value, :grant_id)
    end
  end
end
