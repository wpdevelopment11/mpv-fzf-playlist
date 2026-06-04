# Switch between mpv playlist entries using fzf (with EPG support in XMLTV format)

Jump between mpv playlist entries using your terminal.
Use a fuzzy search to quickly find the entry you are looking for.

If you are watching IPTV you can provide an EPG file in XMLTV format to see
the title of the current TV program and the title and start time of the next one.

Tested only on Linux.

## Screenshots

<p align="center">
    <img src="screenshot_iptv.png" alt="screenshot of a playlist with TV listings" />
</p>

<p align="center">
    <img src="screenshot.png" alt="screenshot of mpv playlist loaded into fzf" />
</p>

## Requirements

* Works on Linux.

  Other operating systems are untested.
* Start your mpv instance with `--input-ipc-server` option, for example:
  ```
  mpv --input-ipc-server=/tmp/mpvsocket playlist.m3u8
  ```
* Make sure that you have installed:
  * [`fzf`](https://github.com/junegunn/fzf)
  * [`jq`]
  * `socat`
  * If you want to use the EPG feature: [`xq`](https://github.com/kislyuk/yq#xml-support) (`xq-python` on Debian/Ubuntu)

## Usage

Copy the `mpvpl` script somewhere in your `PATH`.

To see the current playlist and switch playlist entries, run the following:

```
mpvpl
```

If you are watching IPTV you can pass an EPG in XMLTV format to see
the current and the next TV program:

> The names of channels in your playlist and in the XMLTV file must match.
> Otherwise, TV programs will not be listed.

```
mpvpl https://example.com/xmltv.xml.gz
```

> You can press <kbd>Ctrl</kbd>+<kbd>R</kbd> to reload mpv playlist (and programs if you are using XMLTV).

The provided URL will be cached, and will be downloaded again only if it's changed on a server.

Internally, an `xml.gz` file will be converted to `json.gz` to make it possible to query
it using [`jq`].

You can provide a path to the local XMLTV file (but this is not recommended and only useful for testing):

```
mpvpl /path/to/xmltv.xml.gz
```

## Watch a demo

<video src="https://github.com/user-attachments/assets/798977d4-4ec0-4cff-ad72-8da7e3079540"></video>

## Limitations

* Conversion from XML to JSON is needed to be able to query TV programs using [`jq`]. It may take a lot of time depending on the EPG size, but it's done only once
  for each URL.

[`jq`]: https://github.com/jqlang/jq
