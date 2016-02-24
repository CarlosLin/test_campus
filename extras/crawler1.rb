# encoding: UTF-8

class Crawler
  require 'nokogiri' 
  require 'json'
  require 'open-uri'
  require 'pp'
  require 'mysql2'
  require 'uri'

  def self.get_all_posts_of_page(url)
    begin
      host ="https://www.ptt.cc" 
      count = 0
      doc = Nokogiri::HTML(open(url))
      data = doc.css('.r-ent').css('.title').css('/a[@href]').to_a
      articles_of_page = []
      data.each do |link|
        link = data[count]['href']
        post_id = link.split("/")[3]
        ptt_link = host+link
        title = data[count].text.gsub("'",'\\')
        ptt_id = link.match /[M].\d{10}\.[A-Z].\w{3}/
        puts ptt_id
        doc_article= Nokogiri::HTML(open(ptt_link))rescue OpenURI::HTTPError 
        next if doc_article.nil?
        content_text = doc_article.to_s
        type = content_text[/\看板\<\/span><span class=\"article-meta-value\">(.*?)<\/span>/m, 1]
        author = content_text[/<span class=\"article-meta-value\">(.+?)<\/span>/m, 1]
        contents = content_text[/\d{2}:\d{2}:\d{2}\s\d{4}<\/span>\n<\/div>(.+?)※ 發信站/m, 1]
            if contents == nil
              contents = content_text[/\d{2}:\d{2}:\d{2}\s\d{4}<\/span>\n<\/div>(.+?)※ 文章網址/m, 1]
              if contents == nil
                contents = content_text[/\d{2}:\d{2}:\d{2}\s\d{4}<\/span>\n<\/div>(.+?)※ 編輯/m, 1]
              end
            end
            content = Nokogiri::HTML.fragment(contents).to_s.gsub("'",'\\')
            count +=1
            cover = URI.extract(content, %w(http https))
            cover.keep_if { |t| t =~ /http:\/\/i.imgur/}
        post_data = {
          :ptt_post_id  => post_id,
          :ptt_post_link=> ptt_link,
          :name         => title,
          :content      => content,
          :cover_image  => cover.sample
        }
        articles_of_page.push(post_data)
        sleep 0.1
      end
    rescue Errno::ECONNRESET =>e
        puts e
            sleep 1
            retry
    end
    return articles_of_page
  end

  def self.get_posts(type)
    host ="https://www.ptt.cc"
    first_page = host + "/bbs/#{type}/index.html"
    index_doc = Nokogiri::HTML(open(first_page))
    html = index_doc.css("//div[@class='btn-group pull-right']").css('/a[@class]').to_a
    next_page = html[2]['href']
    all_posts = []
    if next_page == nil
        url = host+ "/bbs/#{type}/index.html"
        puts url
        all_posts.push(get_all_posts_of_page(url)).flatten!
    end
    page_number = html[1]['href'].split("/")[3][5..8].to_i
    count = 0
    page_number.times do |link_number|
      break if count > 0 
      page_number -=1
      url = host+ "/bbs/#{type}/index#{page_number}.html"
      puts url 
      first_page = url
      all_posts.push(get_all_posts_of_page(url)).flatten!
      break if page_number == 0
      count+=1
    end
    Post.create(all_posts)
  end
  def self.get_ptt
    puts "讀取的版名 1.Gossiping 2.Beauty"
    ptt_type = gets.chomp
    get_posts(ptt_type)
  end
end
