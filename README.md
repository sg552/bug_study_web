# 说明

一个工具。

把安全相关的数据库配上去就可以学习了. 例如乌云

只为学习研究wooyun数据库使用

## 功能：

为某个bug增加：是否学习过，是否收藏
为bug增加注释
不能匿名访问，必须登录。

## 安装

操作系统：ubuntu 
ruby 2.5.0
rails: 4.2.10
mysql 5.x

1. 下载代码  
$ git clone https://github.com/sg552/bug_study_web.git
2. cd bug_study_web
3. gem install bundler -v 1.16.2
3. bundle install
4. 修改 config/database.yml
6. bundle exec rake db:create
7. 导入 wooyun 数据库
8. bundle exec rake db:migrate
9. bundle exec rails s 

就可以了。

## 增加用户：

在命令行，打开： $ bundle exec rails c 
然后 User.create email: 'test@my.com', password: '123456'

就可以了。

## 使用

登录后使用

- demo:  http://shentou.sweetysoft.com
- user: demo@shentou.com
- password:  123456

![图片](https://user-images.githubusercontent.com/234533/145322223-72fb41a7-ff70-4e46-a0b6-891e518be8bf.png)

![图片](https://user-images.githubusercontent.com/234533/145322300-2a96dc1c-5325-4b29-9bc1-cd62c6c80387.png)

![图片](https://user-images.githubusercontent.com/234533/145322330-bf732d55-4c8e-4bff-b530-93169c6eaf79.png)


