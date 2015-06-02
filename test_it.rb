#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require "pp"

Bundler.require
Dotenv.load

agent = Mechanize.new(agent: "Chrome")

page = agent.get "https://urlopek.pl/Account/LogOn"

form = page.forms.first

form["UserName"] = ENV["URLOPEK_USERNAME"]
form["Password"] = ENV["URLOPEK_PASSWORD"]

page = form.submit
absence_table = page.search("div#absence > table")

absence_table.search("tr")[1..-1].each do |e|
  _, company, employee, start_date, end_date  = e.search("td").map(&:text).map(&:strip)
  if company.downcase =~ /codest/
    puts "#{employee} od: #{start_date} do: #{end_date}"
  end
end
