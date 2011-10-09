class PageTask
  attr_accessor :name, :url, :time_interval
	
  def initialize(name, url, time_interval)
    @name = name
	@url = url
	@time_interval = time_interval
  end
	
  def to_s
    "[%s] %d - %s \n" % [@name, @time_interval, @url]
  end
  
end