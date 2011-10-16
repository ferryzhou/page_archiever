require './thread_pool'
require './page_archiever'

class TasksRunner

  def initialize(archieves_root)
	@archiever = PageArchiever.new(archieves_root)
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
      pool.process {@archiever.read_and_save_url(page_task.url, page_task.name)} 
    end
    pool.join()
  end

end
