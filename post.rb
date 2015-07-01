class Post
  attr_accessor :item_id, :title, :points
  @@posts = []

  def initialize(item_id, title, points)
    @item_id = item_id
    @title = title
    @url = url
    @points = points
  end

  def comments
    Comment.all.select {|comment| comment.post_id == item_id}
  end

  def add_comment(comment_item_id, content)
    Comment.create(comment_item_id, item_id, url, content)
  end

  def url
    "https://news.ycombinator.com/item?id=#{item_id}"
  end

  class << self

    def create(doc)
      # scrape from doc
      item_id = scrape_id(doc)
      title = scrape_title(doc)
      points = scrape_points(doc)
      # make new Post object
      post = Post.new(item_id, title, points)
      @@posts << post
      # create all comments related to this post
      Comment.create_from_post(doc, item_id)
      # return this Post object
      post
    end

    def scrape_title(doc)
      doc.search('.title').inner_text
    end
    def scrape_id(doc)
      post_id = doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }.join
      post_id[/(\d+)/]
    end
    def scrape_points(doc)
      points = doc.search('.subtext > span:first-child').map { |span| span.inner_text}.join
      points[/(\d+)/]
    end
  end
end