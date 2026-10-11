# Skins: all SVG pictures in one sheet

A skin of any kind (`OSD Skins`, `Meter Skins`, tray `Skins`) can keep its SVG pictures in one file, `Skin.svg`, next to
its `Skin.xml`, instead of one file per picture. The sheet can be opened in a browser or in Inkscape and shows all the
pictures of the skin side by side.

```xml
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="1124" height="431"
     viewBox="0 0 1124 431">
<svg id="Back" x="0" y="0" width="360" height="100" viewBox="0 0 360 100">
  <rect width="360" height="100" fill="#C1C1C1"/>
</svg>
<svg id="Meter" x="370" y="0" width="8" height="24" viewBox="0 0 8 24">
  <rect width="8" height="24" rx="4" fill="#FEFEFE"/>
</svg>
<svg id="Media_PlayPause" x="388" y="0" width="40" height="26" viewBox="0 0 40 26"> ... </svg>
</svg>
```

* Each picture is a `<svg>` directly inside the sheet. Its `id` is the name of the file it stands for, without the
  extension: `Back`, `Mute`, `Meter`, `Meter_Effect`, `Media`, `Media_PlayPause`, `0`, `Digits_20`... (letter case does not
  matter). `x` and `y` only place it on the sheet; `width`, `height` and `viewBox` are its size, as in a file of its own.
* Wherever the skin names a picture (`Image="Media_PlayPause.svg"` in `Skin.xml`, or a picture the skin type always
  looks for, such as `Back`), Volume2 takes the file if there is one, else the `.svg` file of that name, else the part of
  the sheet with that id. A single picture can so be replaced by a file without editing the sheet.
* A `<style>` or `<defs>` directly inside the sheet is shared by all its pictures. A `<style>` or `<defs>` inside a picture
  belongs to it. Ids inside the pictures should differ between pictures (for example `Back_soft`, `Media_soft`) so that the
  sheet also looks right in a browser.
* Light and dark colors work as in a file of its own: `@media (prefers-color-scheme: dark)` rules in a `<style>`.
* `Preview` is the picture the skin lists show (OSD and meter skins). It can be drawn in SVG, which the lists draw sharp
  at any display scaling, or hold the PNG it replaces: `<image width="94" height="24" href="data:image/png;base64,..."/>`.
  A `Preview.png` or `Preview.svg` file is used before it. See
  [Skins - Colorization, previews and tray sizes](Skins%20-%20Colorization%2C%20previews%20and%20tray%20sizes.md).
* PNG pictures stay files; a skin can mix them with a sheet.
* Volume2 reads a sheet once and keeps its parts until the file changes, so a skin loads as fast as from separate
  files.
* Only the pictures directly inside the sheet count: an `<svg id>` nested in a picture is part of that picture, not a
  picture of its own.

How colorization treats a skin's art, the previews in the skin lists and tray icons for every tray size are described in
[Skins - Colorization, previews and tray sizes](Skins%20-%20Colorization%2C%20previews%20and%20tray%20sizes.md).
