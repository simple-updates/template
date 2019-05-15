**simple-template**

```html
<p>
  hi {{user.name}}
</p>

<p>
  welcome to the {{repo.name}} repository, you might want to check out
  those other projects:
</p>

<ul>
  {% for project in projects %}
    {% unless project.fork %}
      <li>
        <a href="{{project.url}}">
          {{project.name}}
        </a>
      </li>
    {% end %}
  {% end %}
</ul>

<p>
  thanks for reading this on a {{"now"|date "%A"|downcase}}
</p>
```

a bit more complicated:

```coffee
{- def random n:1 }
  {- if n | equal 1 | or (n | is_a "float") }
    {< rand | times n }
  {- else }
    {< rand | times n |round }
  {- end }
{ end }

{< random (1 | plus (random 10)) }

{{ user.name }}

some ruby code because why not:

<code>10.times { |i| puts i }</code>
```

(and so much more)

**trying it out without downloading anything**

- copy the content of the [`template.pegjs`](https://raw.githubusercontent.com/simple-updates/template/master/template.pegjs) file
- go to <https://pegjs.org/online> and paste that onto the left pane
- use the right pane for the input and the bottom right pane for the output

**trying it out locally**

- `npm install` then `./parser "something {{|random}}"`
  - see `parser` for options

- `./console` can be helpful too

**current state**

pretty good parser, output of the parser isn't very stable yet

**tests**

see `test/` folder

**inspirations**

very inspired by liquid, json, ruby and coffeescript.

**syntax highlighting**

depending on the context i use either `html` or `coffee` ([see all](https://gist.github.com/localhostdotdev/1e118e70a8b07bb07d12d79f6af772db))
