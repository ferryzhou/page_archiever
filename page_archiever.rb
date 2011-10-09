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
require './thread_pool'

# given a file containing urls and names, 
# extract the corresponding contents and store to local files
class PageArchiever
  
  def initialize(archieves_root)
    @archieves_root = archieves_root
    create_if_missing(archieves_root)
	@thread_count = 2
  end
  
  def run(page_task_array)
    current_hour = Time.new.hour
    puts 'current_hour: ' + current_hour.to_s
    puts "original page_task_array------------>\n" + page_task_array.to_s
    page_task_array.delete_if { |page_task| current_hour % page_task.time_interval != 0 }
    puts "page_task_array -------------->\n" + page_task_array.to_s
    read_and_save_page_tasks(page_task_array, @thread_count)
  end
  
  def read_and_save_page_tasks(page_task_array, thread_count)
    pool = ThreadPool.new(thread_count)
    page_task_array.each do |page_task| 
      pool.process {read_and_save_url(page_task.url, page_task.name)} 
    end
    pool.join()
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


