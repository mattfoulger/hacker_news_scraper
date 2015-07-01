require 'open-uri'
require 'nokogiri'
require 'colorize'
require 'pry'
require_relative 'bad_doc_error'
require_relative 'post'
require_relative 'comment'

url = ARGV[0]

begin
  raise BadDocError, "Not a HackerNews post" unless url[(/https\:\/\/news\.ycombinator\.com\/item\?id\=/)]
  doc = Nokogiri::HTML(open(url))
rescue
  puts "Please enter a URL in the following format:"
  puts " https://news.ycombinator.com/item?id="
end
begin
  raise BadDocError, "No such post" if doc == nil
  post = Post.create(doc)
rescue
  puts "Please enter a valid HackerNews post id"
end



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

