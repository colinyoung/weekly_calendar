class Date
  def same_day_as?(date_or_time)
    if date_or_time.is_a?(Time)
      date_or_time.yday == self.yday && date_or_time.year == self.year
    else
      self == date_or_time
    end
  end
end

class Time
  def same_day_as?(date_or_time)
    if date_or_time.is_a?(Date)
      date_or_time.yday == self.yday && date_or_time.year == self.year
    else
      self == date_or_time
    end
  end
end