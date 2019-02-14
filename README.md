#和谐宝典，在原有的基础上进行了削减不需要的功能
使用方法：
Padrino框架下
gem 'small_harmonious_dictionary', git: ''
再往项目中的config文件夹下新增harmonious_dictionary文件夹，往其增加两个文件chinese_dictionary.txt和english_dictionary.txt,一个是中文敏感词库，一个是英文敏感词库
上述步骤完成后，在Rakefile中添加require 'harmonious_dictionary'
然后执行rake harmonious_dictionary:generate，此时词库已经初始化成功，可以进入使用了！

Rails框架下
#TODO
