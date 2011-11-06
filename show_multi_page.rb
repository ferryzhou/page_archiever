require './multi_page_archiever'

root = '../cancer_htm'
start_url = 'http://www.tianya.cn/new/techforum/ArticlesList.asp?pageno=1&iditem=100&part=0&subitem=%D6%D7%C1%F6%BF%C6';
name = 'tianya_zhongliu';

archiever = MultiPageArchiever.new(root)
archiever.end_count = 2
archiever.run(start_url, name)
