class HomeController < ApplicationController
    before_filter :authorize_user!, :except => [:index]
    def index
    end
    
    def ror 
         render "ror_content"   
    end
    
 
end
