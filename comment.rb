class Comment

  attr_reader :item_id, :post_id, :content
  @@comments = []

  def initialize(item_id, post_id, content)
    @item_id = item_id
    @post_id = post_id
    @url = url
    @content = content
  end

  def url
    "https://news.ycombinator.com/item?id=#{item_id}"
  end

  class << self

    def create_from_post(doc, post_id)
      scrape_comments(doc).each do |comment|
        comment = Comment.new(comment[0], post_id, comment[1])
        @@comments << comment
      end
    end

    def scrape_contents(doc)
      doc.search('.comment > font:first-child').map { |font| font.inner_text}
    end

    def scrape_ids(doc)
      doc.search('.comhead > a:nth-child(2)').map { |a| a['href'][/(\d+)/]}
    end

    def scrape_comments(doc)
      scrape_ids(doc).zip(scrape_contents(doc))
    end

    def all
      @@comments
    end


  end
end