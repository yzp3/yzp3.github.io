{% extends '_layout.swig' %} <!-- _layout.swig首页的基础布局 -->
{% import '_macro/sidebar.swig' as sidebar_template with context %} <!-- sidebar.swig滑动块的布局 -->

{% block title %}{{ title }}{%- if theme.index_with_subtitle and subtitle %} - {{ subtitle }}{%- endif %}{% endblock %}
man
{% block content %}

  <div class="posts-expand">
    {%- for post in page.posts.toArray() %}
      {{ partial('_macro/post.swig', {post: post, is_index: true}) }} <!-- post.swig文章布局 -->
    {%- endfor %}
  </div>
  {% include '_partials/pagination.swig' %} <!-- pagination.swig上一篇、下一篇文章的布局 -->

{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(true) }}s
{% endblock %}