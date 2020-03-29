---
title: next主题的注入
date: 2020-03-22 18:25:04
categories: 前端
tags:
 - 前端
 - Hexo
 - Next主题
---
> 基于 hexo-injects 插件的 Next 主题的[Injects](https://theme-next.org/docs/advanced-settings)对扩展开放，对修改关闭，很好地符合了“开-闭原则”，下面介绍一下 Injects 的使用方法。
<!-- more -->

***

## Next 注入
在主题配置文件_config.yml 中可以找到下面这段配置
```yaml
custom_file_path:
  # head: source/_data/head.swig                      #html中的head
  # header: source/_data/header.swig                  #文章的头部
  # sidebar: source/_data/sidebar.swig                #滑动块
  # postMeta: source/_data/post-meta.swig             #文章设置：创建日期、更新日期...
  # postBodyEnd: source/_data/post-body-end.swig      #文章结束
  # footer: source/_data/footer.swig                  #文章底部
  # bodyEnd: source/_data/body-end.swig               #html的body
  # variable: source/_data/variables.styl             #主题现存样式
  # mixin: source/_data/mixins.styl                   #设备适配
  # style: source/_data/styles.styl                   #所有样式
```

在站点目录下的 source 文件夹下创建相应的文件，再把上述注释去掉，即可使用
### 示例
_source/\_data/styles.styl_ :
```css
.content {
	border-radius: 20px; //文章背景设置圆角
	padding: 30px 60px 30px 60px;
	background:rgba(255, 255, 255, 0.8) none repeat scroll !important;
}

.main-inner {
  padding-top: 20px;
}

//背景图
body {
  background:url(/images/background_black.jpg);
  background-attachment: fixed;
}

.footer{
  background:url(/images/background_black.jpg);
  background-attachment: fixed;
}
.footer-inner{
  text-align: center
}
// 文章摘要配图
// 图片外部的容器方框，限制图片大小
.out-img-topic {
  display: block;
  margin-bottom: 24px;
  max-height: 500px;
  overflow: hidden;
}
// 图片
img.img-topic {
  clear: right;
  display: block;
  float: right;
  margin-left: .7em;
  margin-right: .7em;
  padding: 0;
}


// 文章内链接文本样式
.post-body p a {
  border-bottom: none;
  border-bottom: 1px solid #0593d3;
  color: #0593d3;

  &:hover {
    border-bottom: none;
    border-bottom: 1px solid #fc6423;
    color: #fc6423;
  }
}

.post {
  margin-bottom: 60px;
  margin-top: 60px;
  padding: 25px;
  -moz-box-shadow: 0 0 5px rgba(202, 203, 204, .5);
  -webkit-box-shadow: 0 0 5px rgba(202, 203, 203, .5);
}

// 自定义回到顶部样式
.back-to-top {
  background: url('/images/back2top.png');
  bottom: unset;
  height: 900px; // 图片素材高度
  right: 60px;
  top: -900px;
  transition: all .5s ease-in-out;
  width: 70px; // 图片素材宽度

  // 隐藏箭头图标
  > i {
    display: none;
  }

  &.back-to-top-on {
    bottom: unset;
    top: 100vh < (900px + 200px) ? calc(100vh - 900px - 200px) : 0;
  }
}

```

注入的优先级高于 _theme/next/source/css/\_custom/custom.styl_ ，如果 custom.styl 和 syle.styl 同时重写了 .body，最后呈现的是 syle.styl 的样式。即 CSS 渲染的顺序是 ++style.styl > custom.styl > base.styl++ 。

## 自定义注入


## 参考文章
[Hexo NexT 高阶教程之 Injects](https://www.jianshu.com/p/61dd40458d93)