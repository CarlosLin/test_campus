# encoding: UTF-8

class Crawler
  require 'nokogiri'
  require 'json'
  require 'open-uri'
  require 'pp'
  require 'pg'
  require 'uri'

  def self.get_all_posts_of_page(url)
        count = 0
    begin
      host ="https://www.ptt.cc"
      doc = Nokogiri::HTML(open(url)) rescue Errno::ECONNRESET
      page_data = doc.css('.r-ent')
      need_links = []
      push_counts = page_data.css('.nrec').to_a

      page_data.each_with_index do |link, idx| next if page_data[idx].nil?
      	# next unless page_data[idx].css('.title').css('/a[@href]')
      	# p page_data[idx].css('.title').css('/a[@href]')
          next if push_counts[idx].text != "爆" && push_counts[idx].text.to_i <= 30
                links = page_data[idx].css('.title').css('/a[@href]')
          need_links.push(links)
          # p links
          # p idx
      end
      # p "_________LINKKKKKKKKKKK"
      # p need_links
         get_all_data(need_links)
    end
    
  end

    def self.get_all_data(links)
        host ="https://www.ptt.cc"
      articles_of_page = []
      p links
      p "links_________"
      links.each do |data|
        link = data[0]['href'] rescue nil
        next if link.nil?
        # p link
        # p "link____"
        post_id = link.split("/")[3]
        # p post_id
        # p "post_id___"
        ptt_link = host+link
        doc_article = Nokogiri::HTML(open(ptt_link)) rescue nil
        next if doc_article.nil?
        next if Post.exists?(:ptt_post_link=>ptt_link)
        # p ptt_link
        p "ptt_link___"
        title = data.text.gsub("'",'\\')
        # p title
        # p "title____"
        ptt_id = link.match /[M].\d{10}\.[A-Z].\w{3}/
        # p ptt_id
        # p "ptt_id___"
        # puts ptt_id
    #     doc_article= Nokogiri::HTML(open(ptt_link)) rescue OpenURI::HTTPError
				# next if doc_article.nil?
        content_text = doc_article.to_s
        # p content_text
        type = content_text[/\看板\s(.*?)\s-/m, 1]
        # p type
        # post_data[:type] = type
        author = content_text[/作者<\/span>+[\s\S]*?>([\s\S]*?)<\/span>/m, 1]
        # p author
        contents = content_text[/\d{2}:\d{2}:\d{2}\s\d{4}<\/span>\n<\/div>([\s\S]*?)--\n<span\sclass=\"f2\">※ 發信站/m, 1]
            if contents == nil
              contents = content_text[/\d{2}:\d{2}:\d{2}\s\d{4}<\/span>\n<\/div>(.+?)※ 文章網址/m, 1]
              if contents == nil
                contents = content_text[/\d{2}:\d{2}:\d{2}\s\d{4}<\/span>\n<\/div>(.+?)※ 編輯/m, 1]
              end
            end
        # p contents
            # content = Nokogiri::HTML.fragment(contents).to_s.gsub("'",'\\')
            content = contents.to_s.gsub("'",'\\')
            cover = URI.extract(content, %w(http https))
            # p cover
            cover.keep_if {|t| t =~ /http:\/\/i.imgur/}
        post_data = 
        {
          # :type         => type,
          :ptt_post_id  => post_id,
          :ptt_post_link=> ptt_link,
          :name         => title,
          :content      => content,
          :cover_image  => cover.sample
        }
        # p post_data
        # p "post_data______"
        # articles_of_page.push(post_data)
        Post.create(post_data);
        sleep 0.1
      end
    rescue Errno::ECONNRESET =>e
        puts e
        sleep 1
        retry
    # return articles_of_page
      end

  def self.get_posts(type)
    host ="https://www.ptt.cc"
    first_page = host + "/bbs/#{type}/index.html"
    index_doc = Nokogiri::HTML(open(first_page))
    html = index_doc.css("//div[@class='btn-group pull-right']").css('/a[@class]').to_a
    next_page = html[2]['href']
    all_posts = []
    count = 1400
    page_number = html[1]['href'].split("/")[3][5..8].to_i
    page_number.times do |link_number|
      url = host+ "/bbs/#{type}/index#{count}.html"
      puts url
      # first_page = url
      all_posts.push(get_all_posts_of_page(url)).flatten!
      break if next_page == page_number
      count+=1
    end
    if next_page == nil
        url = host+ "/bbs/#{type}/index.html"
        puts url
        all_posts.push(get_all_posts_of_page(url)).flatten!
    end
  end
  def self.get_ptt
    puts "讀取的版名 1.Gossiping 2.Beauty"
    ptt_type = gets.chomp
    get_posts("Beauty")
  end
end