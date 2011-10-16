require './cancer_pages'
require './tasks_runner'

root = '../cancer_htm'

TasksRunner.new(root).run(cancer_tasks)