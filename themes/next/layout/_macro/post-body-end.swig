<div>
  {% if not is_index %}
    {%- if theme.passage_end_tag.enable %}
      {% include 'passage-end-tag.swig' %}
    {%- endif %}
  {% endif %}
</div>