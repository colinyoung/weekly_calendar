require "week" # Require the week gem

require "weekly_calendar/version"
require "weekly_calendar/railtie"
require "weekly_calendar/calendar"
require "weekly_calendar/helpers"

module WeeklyCalendar

  # Converts active record objects into hashed date format for WC
	def self.to_events(array, date_method=:start_at_date)

    Hash.new.tap do |h|
      array.each do |object|
        k = object.send(date_method).try(:to_date)
        return if k.nil?
        h[k] ||= []
        h[k] << object
      end
    end

  end
end
