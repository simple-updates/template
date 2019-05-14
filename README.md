**simple-template**

```html
<p>
  hi {{ user.name }}
</p>

<p>
  welcome to the {{ repo.name }} repository, you might want to check out
  those other projects:
</p>

<ul>
  {% for project in projects %}
    {% unless project.fork %}
      <li>
        <a href="{{ project.url }}">
          {{ project.name }}
        </a>
      </li>
    {% endunless %}
  {% endfor %}
</ul>

<p>
  thanks for reading this on a {{ "now" | date "%A" | downcase }}
</p>
```

**trying it out without downloading anything**

- copy the [`template.pegjs`](https://raw.githubusercontent.com/simple-updates/template/master/template.pegjs) file
- go to <https://pegjs.org/online>

**trying it out locally**

- `npm install` then `./parser "something {{ "you provide" }}"`
  - see `parser` for options

**tests**

- `bundle` then `ruby test/parser_test.rb`

**goals**

- user-provided templates
- html parser with auto-escaping, text parser without
- short syntax
- no default filters (e.g. `date`, `downcase` and `where` are created by the developer)
- compatibility with json for values
- filters define their input type structure
- minimal size
- user-understandable errors as well as detailed programmer-oriented errors with trace

**maybe**

- a `data` format which is the `value` type from `template`

**current state**

early version of the parser part

**inspirations**

very inspired by liquid, json, ruby and coffeescript.
