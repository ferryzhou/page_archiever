require './page_task'

def array_to_task(array)
  PageTask.new(array[0], array[2], array[1])
end

def arrays_to_tasks(arrays)
  arrays.collect {|x| array_to_task(x)}
end

def cancer_tasks
  
  tasks = arrays_to_tasks([
    ['tianya', 1, 'http://search.tianya.cn/s?tn=sty&rn=10&pn=0&s=0&pid=100&f=0&h=1&q=%22%B5%C3%C1%CB%B0%A9%D6%A2%22&pids=1_853_860_862_878_1030_985_1048_736_825'],
	['yahoo', 1, 'http://ks.cn.yahoo.com/search.php?keyword=%E5%BE%97%E4%BA%86%E7%99%8C%E7%97%87&page=1']
  ])
  
end
