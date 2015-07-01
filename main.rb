require 'open-uri'
require 'nokogiri'
require 'colorize'
require 'pry'
require_relative 'post'
require_relative 'comment'

url = ARGV[0]
doc = Nokogiri::HTML(open(url))
post = Post.create(doc)

puts ""
puts "--------------------------------------------------------------------------".yellow
puts "#{post.title}"
puts "--------------------------------------------------------------------------".yellow
puts "#{post.comments.count} comments".yellow
puts "#{post.points} points".yellow
puts "available at #{post.url}".magenta
puts ""

post.comments.each do |comment|
  puts comment.content
  puts "  " + comment.item_id.magenta
  puts ""
end

