# encoding: UTF-8

Encoding.default_external = 'UTF-8'

require 'hpricot'
require 'open-uri'
require 'net/http'
require 'iconv'
require 'uri'

def gb2312_to_utf8(str); Iconv.iconv('utf-8', 'GBK', str).join; end

# given one start page, archieve, continue on "next page", till end or 
# a certain number of pages

# something like "下一页“
def get_next_page_url(content)
  doc = Hpricot(content)
  element = doc.at("//a[text()='下一页']")
  element.nil? ? nil : URI.escape(element['href'])
end


class MultiPageArchiever

  def initialize(archieves_root)
    @archieves_root = archieves_root
    @end_count = 100
  end

  def end_count=(n)
    @end_count = n
  end

  # real name is <source_name>_<id>
  def run(start_url, source_name)
    raw_source_dir = File.join(@archieves_root, source_name)
    create_if_missing(raw_source_dir)
    url = start_url
	id = 0
	while (not url.nil?) && (id < @end_count)
      puts 'extracting ' + url + ' ...............'
      begin
        source = open(url)
        content = source.respond_to?(:read) ? source.read : source.to_s
        raw_source_path = File.join(raw_source_dir, id.to_s + '.htm')
        File.new(raw_source_path, 'w').puts(content)
        puts 'finshed archiving ' + url + ' ____________________'
        content = gb2312_to_utf8(content)  #assume gb2312 encoding
		next_url = get_next_page_url(content)
		id = id + 1
      rescue
        puts $!
        puts('[Error] can not read url: ' + url + '!');
	    break
      end
	  url = next_url
	end
	puts 'finished all arhieve work --------------------------'
  end

  def create_if_missing(name)
    Dir.mkdir(name) unless File.directory?(name)
  end 
  
end


