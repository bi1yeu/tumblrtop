#Tumblr Top

SPA to display the top original posts for a given [Tumblr][0] tumblelog.
Gives users a quick visualization of the following metrics:
- ratio of reblogged posts to original posts
- notes over time
- most popular post types (photo, text, etc), by post count and note count
- most popular tags, by post count and note count

[Here it is][1]

##Building

```
$ export TUMBLR_CONSUMER_KEY=mYtuMb1r0aUthC0nSuMerKey
$ npm install
$ bower install
$ gulp
```

The default `gulp` task will build and serve the page on localhost:3000.

Jasmine unit tests can be run with `gulp test`.

Get your own [Tumblr OAuth credentials][1].

[0]: https://www.tumblr.com/  "https://www.tumblr.com/"
[1]: http://matthewbilyeu.com/tumblr-top "http://matthewbilyeu.com/tumblr-top/"
[2]: https://www.tumblr.com/oauth/apps "https://www.tumblr.com/oauth/apps"
