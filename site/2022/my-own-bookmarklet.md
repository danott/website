<!--data 2022-07-27 -->

# I kicked this off with a bookmarklet of my own design!

This is a stupid fun idea I've had through many iterations of my site.
Ever since the source of truth was a GitHub repository, as best as I remember.
I finally got around to building it.
A bespoke [bookmarklet](https://bookmarklets.org/what-is-a-bookmarklet/) to begin authoring quick'ish entries.

It determines the current date with rudimentary timezone awareness.
It prompts for a starting title.
Then the big reveal!
It opens a new window pointed at GitHub's "create new file" page to the exact path of the markdown file I want to create. 
With the YAML frontmatter pre-populated.

That's pretty neat.

Here's the source:

```javascript
var date = new Date()
date.setHours(date.getHours() - date.getTimezoneOffset() / 60)
date = date.toISOString().split("T").at(0)
var title = window.prompt("What's a good starter title?")
var filename = "content/blog/" + date + ".md"
var value = "---\ntitle: " + title + "\ndate: " + date + "\n---\n\n"
var url = new URL("https://github.com/danott/www.danott.co/new/main")
url.searchParams.append("filename", filename)
url.searchParams.append("value", value)
window.open(url)
```

And here it is as a link I can drag-and-drop into my browser's bookmarks bar to [create a new blog entry](javascript:void%20function(){var%20t=new%20Date;t.setHours(t.getHours()-t.getTimezoneOffset()/60),t=t.toISOString().split(%22T%22).at(0);var%20e=window.prompt(%22What's%20a%20good%20starter%20title%3F%22),n=%22content/blog/%22+t+%22.md%22,a=%22---\ntitle:%20%22+e+%22\ndate:%20%22+t+%22\n---\n\n%22,o=new%20URL(%22https://github.com/danott/www.danott.co/new/main%22);o.searchParams.append(%22filename%22,n),o.searchParams.append(%22value%22,a),window.open(o)}();).

I used [bookmarklets.org](https://bookmarklets.org/maker/) for the "compilation".
The tool seems dated, with lack of support for some modern JavaScript features like template literals.
Whatever. 
It works fine and I'll rarely have to change it.