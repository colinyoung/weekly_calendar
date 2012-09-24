module WeeklyCalendar
  class Railtie < Rails::Railtie
    ActiveSupport.on_load :action_view do
      require 'weekly_calendar/view_helper'
      include WeeklyCalendar::ViewHelper
    end
  end
end