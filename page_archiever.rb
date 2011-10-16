# extract feed source based on feed_source_feed
# 
# for each feed_source, create a directory with the name from the xml file
# 
# run once every hour
# read feed source files
# check current_hour % update_interval == 0
# put to task list if yes
# after reading, start a thread pool and read_save all urls

require 'open-uri'
require 'net/http'

# given a file containing urls and names, 
# extract the corresponding contents and store to local files
class PageArchiever
  
  def initialize(archieves_root)
    @archieves_root = archieves_root
    create_if_missing(archieves_root)
  end
  
  def read_and_save_url(url, source_name)
    puts 'extracting ' + url + ' ...............'
    begin
      source = open(url)
      content = source.respond_to?(:read) ? source.read : source.to_s
      raw_source_dir = File.join(@archieves_root, source_name)
      create_if_missing(raw_source_dir)
      raw_source_path = File.join(raw_source_dir, Time.now.to_i.to_s + '.htm')
      File.new(raw_source_path, 'w').puts(content)
    rescue
      puts $!
      puts('[Error] can not read url: ' + url + '!');
    end
    puts 'finshed extracting ' + url + ' ____________________'
  end
  
  def create_if_missing(name)
    Dir.mkdir(name) unless File.directory?(name)
  end 
  
end


