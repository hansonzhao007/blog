---
layout: post
title: Jekyll使用总结
author: Hanson Zhao
header-img: img/post/20170326/jekyll_affix_side_bar.webp
categories:
  - Technology
tags:
  - 前端开发
  - 查阅
comments: true
abbrlink: 13169
date: 2017-04-06 00:00:00
---


# 全局变量
## categories
当文章设置了 categories 属性以后，访问该文章时候就会归入对应的 url 路径。
比如设置了：`categories: ['Life']`，那么访问该文章的时候，URL路径就是 http://webname/`Life`/...
比如设置了：`categories: ['Life', 'eassy']`，那么访问该文章的时候，URL路径就是 http://webname/`Life`/`essay`/...
因为 `｛%` 会被 jekyll 解析成内部语法，所以用中文字符 `｛` 替换了 英文字符 `{` 。
```
｛% for category in site.categories %｝

｛｛ category [0] ｝｝ 是 category name
｛｛ category [1] ｝｝ 包含 category  下的 posts

｛\% endfor %｝
```
<!-- more -->
## tags
```
｛\% for tag in site.tags %｝

｛｛ tag[0] ｝｝是 tag name
｛｛ tag[1] ｝｝包含 tag 下的 posts

｛% endfor %｝

```
# 过滤器使用
## 生成二级目录
categories作为一级目录
tags作为二级目录
```
｛% for category in site.categories %｝    
    <ul>
    ｛｛ category[0] ｝｝ (｛｛ category[1].size｝｝)
        <li>        
        ｛% for tag in site.tags %｝
            ｛% assign blogPosts = site.posts | where: 'categories',  category[0] | where: 'tags', tag[0]%｝ // 这里使用 where filter 来找到属于当前category下的 属于tag[0] 的所有文章。
            ｛% if blogPosts.size != 0 %｝
                ｛｛ tag[0] ｝｝ ｛｛ blogPosts.size｝｝
            ｛% endif %｝
        ｛% endfor %｝       
        </li>
    </ul>
｛% endfor %｝
```
最后生成的效果如图：

![效果图](/img/post/20170408/db593a7f-0d24-4e0f-a1ec-58ec7a399ee4.png)


# 一些问题
## jekyll 生成文章过慢
在某天的某刻，突然发现进行一次微小的post文章修改，jekyll serve --watch 命令下，regeneration 需要耗费 20s 多，以往都是 1-2s 就结束了。反复定位，发现是文章的 title 中写了一个 "C++"，而将其改为 “Cpp”以后就好了。虽然不知道为什么，但是问题还是解决了。猜测也许是因为 `+` 被jekyll 解析时候出了问题。

# 参考

[Categories in Jekyll](http://stackoverflow.com/questions/27583597/categories-in-jekyll)
