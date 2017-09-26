class PagesController < ApplicationController
  
  def about
  
  end
  def home
      redirect_to articles_path if login?
  end
end