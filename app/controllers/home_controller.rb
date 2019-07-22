class HomeController < ApplicationController
  def index
  end

  def calendar
    @menus = Menu.all
  end

  def menu 
  end
end
