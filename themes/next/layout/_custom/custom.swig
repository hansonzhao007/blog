{%
  set js_commons = [
    'src/custom.js',
    'src/clipboard.min.js'
  ]
%}

{% for common in js_commons %}
  <script type="text/javascript" src="{{ url_for(theme.js) }}/{{ common }}"></script>
{% endfor %}
