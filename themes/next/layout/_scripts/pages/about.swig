
  <div class="site-author motion-element" itemprop="author" itemscope itemtype="http://schema.org/Person">
  <div  style="margin-bottom: 20px">
    {%- if theme.avatar.url %}
        <img class="site-author-image" itemprop="image"
        src="{{ url_for(theme.avatar.url) }}">
    {%- endif %}
    <p class="site-author-name" itemprop="name">{{ author }}</p>
    </div>
  </div>