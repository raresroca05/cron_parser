#!/usr/bin/env ruby

class CronParser
    attr_reader :minute, :hour, :day_of_month, :month, :day_of_week, :year, :command
  
    def initialize(cron_string)
      fields = cron_string.split
      year_not_present = fields[5].to_i == 0
  
      @minute = fields[0]
      @hour = fields[1]
      @day_of_month = fields[2]
      @month = fields[3]
      @day_of_week = fields[4]
      @year = year_not_present ? nil : fields[5]
      @command = year_not_present ? fields[5..-1].join(' ') : fields[6..-1].join(' ')
    end
  
    def parse_field(field, min= nil, max = nil)
      result = []

      if min == nil && max == nil
        result = field
      elsif field == '*'
        result = (min..max).to_a
      elsif field.include?(',')
        result = field.split(',').map(&:to_i)
      elsif field.include?('-')
        range = field.split('-').map(&:to_i)
        result = (range[0]..range[1]).to_a
      elsif field.include?('/')
        base, step = field.split('/')
        step = step.to_i
        base = base == '*' ? min : base.to_i
        result = (base..max).step(step).to_a
      else
        result = [field.to_i]
      end

      result
    end
  
    def parsed_minute
      parse_field(minute, 0, 59)
    end
  
    def parsed_hour
      parse_field(hour, 0, 23)
    end
  
    def parsed_day_of_month
      parse_field(day_of_month, 1, 31)
    end
  
    def parsed_month
      parse_field(month, 1, 12)
    end
  
    def parsed_day_of_week
      parse_field(day_of_week, 0, 6)
    end

    def parsed_year
      parse_field(year)
    end

    def print_output
      puts "minute " + parsed_minute.join(' ')
      puts "hour " + parsed_hour.join(' ')
      puts "day of month " + parsed_day_of_month.join(' ')
      puts "month " + parsed_month.join(' ')
      puts "day of week " + parsed_day_of_week.join(' ')
      puts "year " + parsed_year
      puts "command " + command
    end
  
    def test_output
      {
        minute: parsed_minute.join(' '),
        hour: parsed_hour.join(' '),
        day_of_month: parsed_day_of_month.join(' '),
        month: parsed_month.join(' '),
        day_of_week: parsed_day_of_week.join(' '),
        year: parsed_year,
        command: command,
      }
    end
  end

  result1 = CronParser.new('*/15 0 1,15 * 1-5 /usr/bin/find -v ss').test_output
  expected_result1 = {
    :minute=>"0 15 30 45",
    :hour=>"0",
    :day_of_month=>"1 15",
    :month=>"1 2 3 4 5 6 7 8 9 10 11 12",
    :day_of_week=>"1 2 3 4 5",
    :year=>nil,
    :command=>"/usr/bin/find -v ss"
  }

  result2 = CronParser.new('*/15 0 1,15 * 1-5 2012 /usr/bin/find -v ss').test_output
  expected_result2 = {
    :minute=>"0 15 30 45",
    :hour=>"0",
    :day_of_month=>"1 15",
    :month=>"1 2 3 4 5 6 7 8 9 10 11 12",
    :day_of_week=>"1 2 3 4 5",
    :year=>"2012",
    :command=>"/usr/bin/find -v ss"
  }

  results = {
    result_1: result1 == expected_result1,
    result_2: result2 == expected_result2
  }

  pp results

  if __FILE__ == $0
    if ARGV.empty?
      puts "Usage: #{$0} '<cron_string>'"
      exit 1
    end
  
    cron_parser = CronParser.new(ARGV[0])
    cron_parser.print_output
  end