module WeeklyCalendar

  class Calendar

    attr_accessor :output_buffer

    def self.as_html(options)
      self.new(options).to_html
    end

    def initialize(options)
      @options = options

      @view = options[:view]
      @date = options[:for] || options[:date] || Date.current
      @events = options[:events] || {}
    end

    def to_s
      @days = days

      content_tag :table, class: "weekly-calendar #{@options[:class]}", id: @options[:id] do
        content_tag(:thead, headings) + content_tag(:tbody, body)
      end
    end

    def days
      start_week = (@date - 1.week)
      if ![0,6].include?(@date.wday) # is a weekday
        start_week -= 1.week
      end
      if @options[:weekend]
        start_week.week
      else
        start_week.week[1..5]
      end
    end

    def headings
      content_tag :tr do
        String.new.html_safe.tap do |s|
          s << time_scale_heading if @options[:time_scale]
          @days.each do |d|
            # @todo Localize the month/day order
            s << render_heading(d)
          end
        end
      end
    end

    def body
      content_tag :tr do
        String.new.html_safe.tap do |s|
          s << time_scale if @options[:time_scale]
          @days.each do |date|
            others = [ class: date_classes(date), :'data-date' => date.to_date ]
            s << content_tag(:td,
                              date_box(date) + events_ending_this_week(days, date) + events_for_date(date),
                              *others)
          end
        end
      end
    end

    def time_scale
      content_tag :td, class: 'wc-time-scale' do
        String.new.html_safe.tap do |s|
          @options[:time_scale].each_with_index do |h,i|
            time_txt = (Time.utc(2000, 1, 1, @options[:time_scale].first, 0, 0) + i.hours).strftime("%l:%M %p")
            s << content_tag(:div, time_txt, class: 'wc-time-scale-hour')
          end
        end
      end
    end

    def time_scale_heading
      content_tag :th, "", class: 'wc-time-scale-heading'
    end

    def date_box(date)
      content_tag :div, date.mday, class: 'wc-date'
    end

    def events_for_date(date)
      events = @events.delete(date.to_date)
      return if events.nil?

      content_tag :div, class: 'wc-events' do
        safe_str do |s|
          events.each do |event|
            next if event.nil?

            s << render_event(event, on: date.to_date)
          end
        end
      end
    end

    def events_ending_this_week(week, date)
      unless (events = events_ending_on(date)).empty?
        content_tag :div, class: 'wc-events-ending' do
          safe_str do |s|
            events.compact.each do |event|
              next if event.start_at_date >= week.first.to_date
              s << render_event(event, on: date.to_date)
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

    protected

    def render_event(event, options={})
      content_tag(:div, class: "wc-event-container wc-event-duration-#{event.duration} wc-event-offset-#{event.start_time_offset}  wc-days-#{[event.days(options[:on] || options[:date]), 5].min}") do
        @view.render 'weekly_calendar/event', event: event
      end
    end

    def render_heading(date, options={})
      content_tag(:th, class: date_classes(date)) do
        @view.render 'weekly_calendar/heading', date: date
      end
    end

    def events_ending_on(date)
      Array.new.tap do |a|
        @events.each do |date,events|
          events.each do |event|
            a << event if event.end_at_date == date.to_date
          end
        end
      end
    end

    def date_classes(date)
      Array.new.tap do |k|
        k << "today" if date.same_day_as?(Date.current)
        k << "past" if date.past?
      end
    end

  end
end
