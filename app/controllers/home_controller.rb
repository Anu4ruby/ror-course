class HomeController < ApplicationController
    before_filter :authorize_user!, :except => [:index]
    def index
    end

    def ror
      render "ror_content"
    end

    # def edit
    #   @home = Home.find(params[:id])
    #   authorize! :read, @home
    # end

    # def update
    #   @home = Home.find(params[:id])
    #   authorize! :read, @home
    # end

end
