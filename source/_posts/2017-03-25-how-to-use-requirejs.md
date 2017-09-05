---
layout:     post
title:      "10分钟入门requireJs"
subtitle:   "入门requireJs的操作心得"
date:       2017-03-25
author:     "Hanson Zhao"
header-img: "img/post/20170325/requirejs.webp"
catalog:    true
categories: ['Technology']
timeline:   true
tags:
    - 前端开发
    - JavaScript
---
# 引入
---
下载 `requireJs`，然后在 `head` 中

```javascript
<script src="js/require.js" data-main="js/main" defer async="true"></script>
```

`async` 属性表明这个文件需要异步加载，避免网页失去响应。IE不支持这个属性，只支持 `defer`，所以把 `defer` 也写上。

`data-main` 属性的作用是，指定网页程序的主模块。在上例中，就是js目录下面的 `main.js`，这个文件会第一个被 `require.js` 加载。由于`require.js` 默认的文件后缀名是js，所以可以把 `main.js` 简写成 `main`。

# 基本API
---
`require` 会定义三个变量：**define**, **require**, **requirejs**，其中 `require` === `requirejs`，一般使用 `require` 更简短

* define 从名字就可以看出这个api是用来定义一个**模块**
* require 加载依赖模块，并执行加载完后的回调函数

比如我们想写一个 a.js 的模块，实现一个功能：

```javascript
define(function(){
    function fun1(){
        alert("it works");
    }

    fun1();
})
```
这里通过 `define` 函数定义了一个模块，这是 `requirejs` 的标准写法。如果想在页面中使用该 js ，可以直接在 `html` 文件中调用：

```javascript
require(["js/a"]);
```

如果我们的网页目录如下：

![Alt text][1]

并且 `index.html` 内容如下，通过主动 `require` 的方式调用 a.js：

```javascript
<!DOCTYPE html>
<html>
    <head>
        <script type="text/javascript" src="js/lib/require.js"></script>
        <!-- 这里只是主动加载了a.js，并没有定义加载结束后的回调函数，其功能即为只执行a.js中代码 -->
        <script type="text/javascript">
            require(["js/a"]);
        </script>
    </head>
    <body>
      <span>body</span>
    </body>
</html>
```

这时候网页就会弹出一个alert 对话框：
![Alt text][2]


如果将 `index.html` 写成如下：

```javascript
<!DOCTYPE html>
<html>
    <head>
        <script type="text/javascript" src="js/lib/require.js"></script>
        <script type="text/javascript">
            require(["js/a"], function(){
                alert("call back!");
            });
        </script>
    </head>
    <body>
      <span>body</span>
    </body>
</html>
```

那么会在 'It works' 后，再弹出一个对话框：
![Alt text][3]


# 加载文件和全局配置
也许你会说，这样调用的方式，如果我有 a,b,c,d... 等 js 代码，不还是得一个个写到 `head` 里的 `<script>` 标签内调用么。不急，下面才是重点。

首先我们在 js 目录下新建一个 `main.js`：

![Alt text][4]


然后在 `main.js` 中写如下代码：

```javascript
require.config({
    paths : {
        "a" : "js/a"   
    }
})

require(['a'],function(){
alert('finish load');
});
```
然后在 `index.html` 中这样写：

```javascript
<!DOCTYPE html>
<html>
    <head>
        <script type="text/javascript" src="js/lib/require.js" ></script>
       <script>
           require(['js/main']);
       </script>
    </head>
    <body>
      <span>body</span>
    </body>
</html>
```

这里用到了 `require.config`。`require.config` 是用来配置模块加载位置的。即给我们的 js 模块，取一个 别名，之后进行 `require` 的时候，就不用以输入路径的方式来调用，直接写这个 别名 就行。

可以看到上面代码写 `require` 的时候，直接是使用 `require(['a']` 而不是之前的 `require(["js/a"]`。

这样如果我们有很多的代码，就可以在 `main.js` 中，先配置各个模块的路径，并起别名，然后挨个 `require` 调用就是了。就不用对 `head` 标签进行修改。

同时如果我们在 `index.html` 中这样写：

```javascript
<script type="text/javascript" src="js/lib/require.js" data-main="js/main" defer async="true"></script>
```

这里 `data-main` 属性的作用是，指定网页程序的主模块。在上例中，就是js目录下面的 `main.js`，这个文件会自动被 `require.js` 加载。这样我们就只用写一个 `<script>` 标签，就实现了对所有的 js 模块的调用。

`data-main` 还有一个重要的功能：
当 `script` 标签指定 `data-main` 属性时，`require` 会默认的将 `data-main` 指定的 js 为根路径。即之后如果写 `require` 来调用 js 模块，不需要再添加 'js' 目录前缀。

`async` 属性表明这个文件需要异步加载，避免网页失去响应。IE不支持这个属性，只支持 `defer`，所以把 `defer` 也写上。

下面是使用 `data-main` 属性时候的 html 和 js 文件写法：

```javascript
<!DOCTYPE html>
<html>
   <head>
       <script type="text/javascript" src="js/lib/require.js" data-main="js/main" defer async="true"></script>
    </head>
    <body>
       <span>body</span>
    </body>
</html>
```

```javascript
require.config({
    //这里看到指定 a.js 模块路径的时候，并没有写上其路径前缀 'js/'，这就是 data-main 属性的作用
    paths : {
        "a_alias" : "a"   
    }
})

require(['a_alias'],function(){
alert('finish load');
});

```

# 加载不符合AMD规范模块
---
标准的写法是需要使用一个：
```javascript
define(function(){
    // your code here
});
```
将你的代码写在这个 `define` 内部。但是我们如果想要使用一个不是这种标准的 js 模块怎么破？

这里就要使用到 `shim`。我们看下面的完整配置 `main.js` ：
```javascript
requirejs.config({
        paths: {
            jquery: [               
                'lib/jquery.min'
            ],
            bootstrap: [
                '//cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min', // 这里支持输入多个备选路径，前一个失败就是选择下一个
                'lib/bootstrap.min'
            ],
            my:'my'
        },
        shim:{
            'bootstrap':{
                deps:['jquery'] // 这里指定依赖关系，bootstrap 要在 jquery 加载完成之后再加载
            },
            'my':{
                deps:['jquery','bootstrap'],
                exports:'my_alis'
            }
        }
    });

    require([
        'jquery','bootstrap','my'
        ],
        function($, my_alis){
            // my 中的变量和函数，只在这里有效。
        });
```

这里假设我使用了 `jquery` 和 `bootstrap` 模块，还有一个自己写的业务脚本 `my.js`。 `my.js` 因为要依赖于 `jquery` 和 `bootstrap` 所以在依赖关系中写了上面的配置。

关键在于 `export` 关键字的声明。这样我们就可以加载一个没有使用 `AMD` 规范编程的 js 模块了。并且模块的所有变量，和函数，都不是在全局域的，只在 回调函数中有效。从而避免了全局变量的污染问题。


# 参考：
---
* [JS模块化工具requirejs教程(二)：基本知识](http://www.runoob.com/w3cnote/requirejs-tutorial-2.html)
* [Javascript模块化编程（三）：require.js的用法](http://www.ruanyifeng.com/blog/2012/11/require_js.html)

[1]: /img/post/20170325/f9a21c59-60fe-4757-ba4d-5ce2db23756f.png
[2]: /img/post/20170325/4cb5a7d9-a6f5-46fe-91be-88b60ac7a2eb.png
[3]: /img/post/20170325/ab9e13af-eb74-4469-a451-533c1ab52760.png
[4]: /img/post/20170325/dc5e5da3-fbce-4713-a010-dacae5bbd7f6.png
