module ReuProgram
  class SnippetsController < AdminController
    before_action :authenticate_program_admin!, except: [:index]
    
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
      @snippet = Snippet.find(params[:id])
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
