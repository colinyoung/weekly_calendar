module WeeklyCalendar
  module ViewHelper

    def weekly_calendar(options)
      WeeklyCalendar::Calendar.as_html(options.merge(view: self))
    end
      
  end
end