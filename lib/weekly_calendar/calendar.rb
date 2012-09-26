module WeeklyCalendar
  
  class Calendar

    attr_accessor :output_buffer
    
    def self.as_html(options)
      self.new(options).to_html
    end
    
    def initialize(options)
      @options = options
      
      @view = options[:view]
      @date = options[:for] || options[:date] || Date.today
      @events = options[:events] || {}
    end
    
    def to_s
      @days = days
      
      content_tag :table, class: "weekly-calendar #{@options[:class]}" do
        content_tag(:thead, headings) + content_tag(:tbody, body)
      end
    end
    
    def days
      start_week = (@date - 1.week)
      if @options[:weekends]
        start_week.week
      else
        start_week.week[1..5]
      end
    end
    
    def headings
      content_tag :tr do
        String.new.html_safe.tap do |s|
          @days.each do |d|
            # @todo Localize the month/day order
            s << content_tag(:th, "#{Date::ABBR_DAYNAMES[d.wday]} #{d.month}/#{d.mday}")
          end
        end
      end
    end
    
    def body
      content_tag :tr do
        String.new.html_safe.tap do |s|
          @days.each do |date|
            s << content_tag(:td, events(date))
          end
        end
      end
    end
    
    def events(date)
      events = @events[date.to_date]
      return if events.nil?
      
      content_tag :ul do
        safe_str do |s|
          events.each do |event|
            next if event.nil?
            
            s << content_tag(:div, class: 'wc-event-container') do
              @view.render 'weekly_calendar/event', event: event
            end
          end
        end
      end
    end
    
    def to_html
      to_s.html_safe
    end
    
    def safe_str(&block)
      String.new.html_safe.tap(&block)
    end
    
    def content_tag(*args, &block)
      @view.content_tag(*args, &block)
    end
    
  end
end