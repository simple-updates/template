  'regular text'
  'so how do you do this? with {}? or %?'
  '{{ user.names | join ", " }}',
  """
    {% if user.admin %}
      {{ "delete everything" | link_to "/secret/button" }}
    {% endif %}
  """,
  """
    {% for user in users %}
      {{ user.name }}
    {% endfor %}
  """
