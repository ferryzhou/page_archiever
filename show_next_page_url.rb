require './multi_page_archiever'

source = open('tianya_zhongliu.htm')
#source = open('../cancer_htm/tianya_zhongliu/1.htm')
content = source.respond_to?(:read) ? source.read : source.to_s

content = content.force_encoding('GBK').encode('UTF-8')

p get_next_page_url(content)
