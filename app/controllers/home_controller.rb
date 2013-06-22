class HomeController < ApplicationController
    before_filter :authorize_user!, :except => [:index]
    def index
    end
end
