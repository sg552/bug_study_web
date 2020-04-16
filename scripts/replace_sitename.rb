ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'

bug = Bug.find(88818).wybug_detail

Bug.all.each do |bug|
  puts "== doing: #{bug.id}"
  old_content = bug.wybug_detail
  new_content = old_content.gsub("http://static.loner.fm/upload", "http://showmethemoney.hnengdata.com/image_security/10-16")
  bug.wybug_detail = new_content
  bug.save!
end

puts "== ok"
