# mjml-http-server

A self-hosted alternative to the mjml API. Built with express.

The API is compatible with https://mjml.io/api in that it only exposes one
endpoint - `/v1/render`, but doesn't require authentication. You should probably
run this within your own private network.

#### Why?

You're writing an app in another language than Javascript and need to interop
with MJML. Instead of embedding NodeJS in your Python image you can call MJML
compilation over HTTP.

You can alternatively use the [MJML API](https://mjml.io/api), but it's
currently invite only and has privacy implications (do you want your emails to
be sent to yet another third party?).

For an elaborate discussion see: https://github.com/mjmlio/mjml/issues/340

#### Usage

```
docker run -p 15500:15500 danihodovic/mjml-server
```

```
$ http POST localhost:15500/v1/render
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 2141
Content-Type: application/json; charset=utf-8
Date: Mon, 15 Jul 2019 12:26:48 GMT
ETag: W/"85d-hn49R397DBvYcOi5/4cb+gcoi/I"
X-Powered-By: Express

{
    "html": "\n    <!doctype html>\n    ..."
}
```

#### Configuration

A list of available configuration options can be found in
[./lib/parse_args.js](./lib/parse_args.js).


## Runtime security updates

The Docker image and CI use Node.js 24.22.1. `npm ci` keeps application
packages at the versions in `package-lock.json` during a runtime update.

Build ARM64 with `docker build --pull --platform linux/arm64 -t IMAGE:TAG .`.
Run `docker run --rm --entrypoint npm IMAGE:TAG test` before publishing.
Use a new versioned tag in `public.ecr.aws/u3h9o2q8/reversso-mjml-server`
and deploy the resulting immutable digest to `service-mjml` in `staging-arm`.
Verify authentication, HTML output, target health and `node --version`, then
promote that same digest to `production-arm`. Retain the preceding ECS task
definition for operational rollback. Update the pinned runtime and its check
together for future security releases.
