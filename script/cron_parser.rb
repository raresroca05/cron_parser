#!/usr/bin/env ruby

class CronParser
  SPECIAL_STRINGS = {
    '@yearly' => '0 0 1 1 *',
    '@annually' => '0 0 1 1 *',
    '@monthly' => '0 0 1 * *',
    '@weekly' => '0 0 * * 0',
    '@daily' => '30 12 * * *',
    '@midnight' => '0 0 * * *',
    '@hourly' => '0 * * * *'
  }

  def initialize(cron_string)
    cron_string = SPECIAL_STRINGS[cron_string] || cron_string
    fields = cron_string.split
    
    @minute = fields[0]
    @hour = fields[1]
    @day_of_month = fields[2]
    @month = fields[3]
    @day_of_week = fields[4]
    @command = fields[5..-1]&.join(' ')
  end

  def parse_field(field, min, max)
    result = []

    if field == '*'
      result = (min..max).to_a
    elsif field&.include?(',')
      result = field.split(',').map(&:to_i)
    elsif field&.include?('-') && field&.include?('/')
      range, step = field.split('/')
      range_start, range_end = range.split('-').map(&:to_i)
      result = (range_start..range_end).step(step.to_i).to_a  
    elsif field&.include?('-')
      range = field.split('-').map(&:to_i)
      result = (range[0]..range[1]).to_a
    elsif field&.include?('/')
      base, step = field.split('/')
      step = step.to_i
      base = base == '*' ? min : base.to_i
      result = (base..max).step(step).to_a
    else
      result = [field&.to_i]
    end

    result
  end

  def parsed_minute
    parse_field(@minute, 0, 59)
  end

  def parsed_hour
    parse_field(@hour, 0, 23)
  end

  def parsed_day_of_month
    parse_field(@day_of_month, 1, 31)
  end

  def parsed_month
    parse_field(@month, 1, 12)
  end

  def parsed_day_of_week
    parse_field(@day_of_week, 0, 6)
  end

  def print_output
    puts "minute " + parsed_minute.join(' ')
    puts "hour " + parsed_hour.join(' ')
    puts "day of month " + parsed_day_of_month.join(' ')
    puts "month " + parsed_month.join(' ')
    puts "day of week " + parsed_day_of_week.join(' ')
    puts "command " + (@command || '')
  end
end

if __FILE__ == $0
  if ARGV.empty?
    puts "Usage: #{$0} '<cron_string>'"
    exit 1
  end

  cron_parser = CronParser.new(ARGV[0])
  cron_parser.print_output
end
