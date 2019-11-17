安装hexo：`npm install -g hexo-cli`
	如果报错，可以使用 npm install `-u` hexo-cli 替代 (-u是只装在本用户）

安装 Hexo 完成后，请执行下列命令，Hexo 将会在指定文件夹中新建所需要的文件。
```c
$ hexo init <folder>
$ cd <folder>
$ npm install
```


如果要开启站内搜索，需要安装 `hexo-generator-searchdb`
```c
npm install hexo-generator-searchdb --save
```

这样在站点 `_config.yml`中添加：
```c
search:
  path: search.xml
  field: post
  format: html
  limit: 10000
```
之后，才会生成 search.xml 文件

部署参考 [打造个性超赞博客](https://io-oi.me/tech/hexo-next-optimization/#%E9%83%A8%E7%BD%B2%E5%8D%9A%E5%AE%A2%E5%88%B0-github-pages)
