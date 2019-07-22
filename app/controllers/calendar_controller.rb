class CalendarController < ApplicationController
  def index
    @menus = Menu.all
  end

  def menu
    @menu = Menu.find_by_date_and_menu_type params[:day], params[:type]
  end
end
