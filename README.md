# Luvit-livereload

An implementation of the LiveReload server in Luvit. It's an alternative to the graphical [http://livereload.com/](http://livereload.com/) application, which monitors files for changes and reloads your web browser.

# Example Usage

You can use this by either adding a snippet of code to the bottom of your HTML pages **or** install the Browser Extensions.

## Method 1: Add browser extension

Install the LiveReload browser plugins by visiting [http://help.livereload.com/kb/general-use/browser-extensions](http://help.livereload.com/kb/general-use/browser-extensions).

Only Google Chrome supports viewing `file:///` URLS, and you have to specifically enable it. If you are using other browsers and want to use `file:///` URLs, add the JS code to the page as shown in the next section.

## Method 2: Add code to page

Add this code:

```
<script>
  document.write('<script src="http://' + (location.host || 'localhost').split(':')[0] +
  ':35729/livereload.js?snipver=1"></' + 'script>')
</script>
```

Note: If you are using a different port other than `35729` you will
need to change the above script.

# Running LiveReload

To use the api within a project:

```shell
$ lit install cyrilis/livereload
```

Then, create a server and fire it up.

```lua
local liveReload = require("./init.lua")
liveReload({
    path = '/User/Workspace/test',
    debug = true,
    exclusion = {"deps"}
})
```

## Using the `originalPath` option:

```lua
-- server.lua
local liveReload = require("./init.lua")
liveReload({
    path = '/User/Workspace/test',
	originalPath: "http://domain.com"
})
```

Then run the server:

`$ luvit server.lua`

Then, assuming your HTML file has a stylesheet link like this:

```html
<!-- html -->
<head>
    <link rel="stylesheet" href="http://domain.com/css/style.css">
</head>
```

When `/User/Workspace/test/css/style.css` is modified, the stylesheet will be reload.

# API Options

The `livereload()` method supports a few basic options, passed as a lua table:

- `port` is the listening port. It defaults to `35729` which is what the LiveReload extensions use currently.
- `exts` is an array of extensions you want to observe. The default extensions are  `html`, `css`, `js`, `png`, `gif`, `jpg`,
  `php`, `php5`, `py`, `rb`,  `erb`, and `coffee`.
- `applyJSLive` tells LiveReload to reload JavaScript files in the background instead of reloading the page. The default for this is `false`.
- `applyCSSLive` tells LiveReload to reload CSS files in the background instead of refreshing the page. The default for this is `true`.
- `applyImgLive` tells LiveReload to reload image files in the background instead of refreshing the page. The default for this is `true`. Namely for these extensions: jpg, jpeg, png, gif
- `exclusions` lets you specify files to ignore. By default, this includes `.git/`, `.svn/`, and `.hg/`
- `originalPath` Set URL you use for development, e.g 'http:/domain.com', then LiveReload will proxy this url to local path.
- `overrideURL` lets you specify a different host for CSS files. This lets you edit local CSS files but view a live site. See <http://feedback.livereload.com/knowledgebase/articles/86220-preview-css-changes-against-a-live-site-then-uplo> for details.
- `usePolling` Poll for file system changes. Set this to true to successfully watch files over a network.

# License

Copyright (c) 2016 Cyril Hou \<houshoushuai@gmail.com\>

Released under the MIT license. See `LICENSE` for details.

