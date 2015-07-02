require 'open-uri'
require 'nokogiri'
require 'colorize'
require 'pry'
require_relative 'bad_doc_error'
require_relative 'post'
require_relative 'comment'

url = ARGV[0]

begin
  doc = Nokogiri::HTML(open(url))
  raise BadDocError, "No such post" if doc == nil
  post = Post.create(doc)
rescue
    puts "Please enter a valid HackerNews post id"
end



puts ""
puts "#{post.title}".yellow
puts ""
puts "submitted by #{post.user}".green
puts "#{post.comments.count} comments".yellow
puts "#{post.points} points".yellow
puts "available at #{post.url}".magenta
puts ""

post.comments.each do |comment|
  puts comment.user.green
  puts comment.content
  puts "  " + comment.item_id.magenta
  puts ""
end

