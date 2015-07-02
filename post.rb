class Post
  attr_accessor :item_id, :title, :points, :user
  @@posts = []

  def initialize(item_id, title, points, user)
    @item_id = item_id
    @title = title
    @points = points
    @user = user
    # calls url method, derives from item_id
    @url = url
  end

  def comments
    Comment.all.select {|comment| comment.post_id == item_id}
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
      user = scrape_user(doc)
      # make new Post object
      post = Post.new(item_id, title, points, user)
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
    def scrape_user(doc)
      doc.search('.subtext > a:nth-child(2)').map { |a| a.inner_text}.join
    end
  end
end