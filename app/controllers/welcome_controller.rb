class WelcomeController < ApplicationController

  def index
  	@entries = FeedEntry.all(:limit => 10, :order => "published desc")
  	
  end

end
