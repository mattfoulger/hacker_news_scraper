class Comment

  attr_reader :item_id, :post_id, :content, :user
  @@comments = []

  def initialize(item_id, post_id, content, user)
    @item_id = item_id
    @post_id = post_id
    @content = content
    @user = user
    # gets from url method, derived from id
    @url = url
  end

  def url
    "https://news.ycombinator.com/item?id=#{item_id}"
  end

  class << self

    def create_from_post(doc, post_id)
      zip_comments(doc).each do |comment|
        comment = Comment.new(comment[0], post_id, comment[1], comment[2])
        @@comments << comment
      end
    end

    def scrape_contents(doc)
      doc.search('.comment > font:first-child').map { |font| font.inner_text}
    end

    def scrape_ids(doc)
      doc.search('.comhead > a:nth-child(2)').map { |a| a['href'][/(\d+)/]}
    end

    def scrape_user(doc)
      doc.search('.comhead > a:first-child').map { |a| a.inner_text}
    end

    def zip_comments(doc)
      scrape_ids(doc).zip(scrape_contents(doc), scrape_user(doc))
    end

    

    def all
      @@comments
    end


  end
end