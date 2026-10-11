# OSD skins: the media OSD and buttons

This page describes what a skin (`OSD Skins\<name>\Skin.xml`) can do for the media OSD, which shows the playing track when
the media keys are pressed, and how an element of a skin can be made a button. All coordinates are in skin pixels; the
OSD stretches them with its size setting.

## The Media element

The media OSD is one element next to `<OSD>`, with all its parts inside it. A skin has a media OSD when it has an enabled
`<Media>`; only then do its Skin Settings have the media option.

```xml
<OSD>
  ...the volume OSD...
</OSD>
<Media Enable="true" Image="Media.svg" Keys="true">
  <Cover Enable="true" X="264" Y="18" Size="36" Radius="4"/>
  <Title Enable="true" X="54" Y="28" Alignment="0" MaxWidth="256">
    <Font Size="13" Color="#E4000000" ColorDark="#FFFFFFFF" Name="Segoe UI" Bold="false" Italic="false"/>
  </Title>
  <Artist .../>
  <PlayPause Enable="true" X="28" Y="29" Image="Media_PlayPause.svg">
    <Click Grow="7" HoverColor="System" PressedColor="AccentDark2"/>
  </PlayPause>
  <Previous Enable="true" X="23" Y="57" Image="Media_Previous.svg"> <Click Grow="3"/> </Previous>
  <Next Enable="true" X="41" Y="57" Image="Media_Next.svg"> <Click Grow="3"/> </Next>
  <Progress Enable="true" X="64" Y="62" Width="166" Height="3" TrackColor="#1F000000" FillColor="Colorization"
            TrackColorDark="#33FFFFFF">
    <Click Grow="6"/>
  </Progress>
  <Time Enable="true" Format="%e/%d" X="296" Y="64" Alignment="2" MaxWidth="0"> <Font .../> </Time>
</Media>
<Layers>
  <Layer Enable="true" Image="Media_Glow.svg" X="0" Y="0" LayerIndex="0" Osd="Media"/>
</Layers>
```

* `Media Image`: the picture the media OSD is drawn on, two frames side by side: the left one shown while the track plays,
  the right one while it is paused. The OSD is as big as one frame. Without `Image` the media OSD is drawn on the skin's
  background (`Back.png` / `Back.svg`), so give it a picture of its own only when the background shows things of the
  volume OSD. Parts of the volume OSD that the background would otherwise carry, such as the empty track of the volume
  bar or a speaker icon, can be layers of the volume OSD (`<Layers>` next to `<OSD>`): those are not drawn on the media OSD.
  A layer with `HideOnMute="true"` is not drawn while the sound is muted, for a skin whose mute background (`Mute.svg`)
  shows its own version of it, such as a crossed-out speaker. Give the layer with the empty track the `X`, `Y` and size of
  the `Meter`: every picture is placed on whole pixels on its own, so a track in the background or at another place can be
  a pixel off the bar at sizes such as 125%.
* `Media Keys`: whether the media keys show this skin's media OSD. It is on unless the skin turns it off; the user turns
  it on or off in the Skin Settings of the skin.
* `Cover`: the album art, a rounded square. `Radius="0"` is a plain square.
* `Title`, `Artist`, `Time`: text like any text element. `X`, `Y` is the point the text is aligned to (the vertical
  center); for `Alignment="2"` (right) it is the right edge. A text is cut with an ellipsis at `MaxWidth` (an absolute x
  in the frame, 0 for none).
* `Time Format`: `%e` elapsed time, `%d` length of the track, `%r` time left, `%p` percent played, `%%` a percent sign.
  The default is `%e/%d` (`00:12/02:00`). Nothing is shown for a player that reports no length (a live stream).
* `PlayPause`, `Previous`, `Next`: the buttons, each an image at `X`, `Y` (its top left corner). The play/pause image
  holds two frames side by side, play on the left and pause on the right; like a player, it shows what a click does: play
  while the track is paused, pause while it plays. A button
  always runs its action; the `Click` inside it only gives its look.
* `Progress`: a thin bar with rounded ends. The colors take the forms of the skin's colorization: `#AARRGGBB` (with the
  alpha digits), `System` (the accent shade of the Windows 11 flyout), an accent shade name (`AccentLight3` ...
  `AccentDark3`), `Colorization` (the color a colorized meter is drawn in: the Windows accent or the color picked in
  the skin settings, so the bar matches the volume bar), or a number (`-1` is the same as `Colorization`).
  `TrackColorDark` and `FillColorDark` are used in a dark Windows color scheme. With a `Click` inside it, a click on
  the bar goes to that part of the track, and a drag along it shows the place and goes there on release (a player that
  does not allow seeking ignores it). The bar grows under the pointer.
* Layers of the media OSD are in the skin's `<Layers>` (next to `<OSD>`) with `Osd="Media"` on the `Layer`: only the
  media OSD draws them, and it draws no layer without `Osd`. `LayerIndex="0"` is drawn on the picture under the other
  elements, any other value over them.

## Buttons

An element becomes a button with a `Click` element inside it (a click, not a drag: the OSD can still be dragged). Its area
is the element itself.

```xml
<Cover Enable="true" X="264" Y="18" Size="36" Radius="4">
  <Click Action="MediaPlayPause"/>
</Cover>
...
<Layers>
  <Layer Enable="true" Image="Mute_Button.svg" X="300" Y="20" LayerIndex="5">
    <Click Action="Mute" Osd="Volume" HoverColor="System" PressedColor="AccentDark2"/>
  </Layer>
</Layers>
```

The elements that take a `Click`: `PlayPause`, `Previous`, `Next`, `Progress`, `Cover` and a `Layer` (of the volume OSD or
of the media OSD), and on the volume OSD `Meter`, `MeterEffect` and `MeterMuteEffect`.

```xml
<Meter X="63" Y="58" Orientation="BitMoveRight" Min="0" Max="225" HideOnMute="false" Colorize="true">
  <Click Grow="2"/>
</Meter>
<MeterEffect Enable="true" Orientation="BitStripBottom" Min="0" Max="3" LayerIndex="0" HideOnMute="true" X="16" Y="56">
  <Click Action="Mute" Grow="3" HoverColor="#FFCFE8FF" PressedColor="#FF8FC4F5"/>
</MeterEffect>
<MeterMuteEffect Enable="true" LayerIndex="0" X="16" Y="55">
  <Click Action="Mute" Grow="3" HoverColor="#FFCFE8FF" PressedColor="#FF8FC4F5"/>
</MeterMuteEffect>
```

* `Meter`: a click on the volume bar sets the volume to that place on it, and a drag along it changes the volume as it
  goes (`Volume`, its default action). The bar is
  where the meter is drawn: the path of the knob for `BitMoveRight` and `BitMoveUp` (the knob's centre is the volume),
  the picture for `Horizontal`, `Vertical` and the strips (along it from the left; `Vertical` from the bottom). A
  `Rotate` meter takes no click.
* `MeterEffect`, `MeterMuteEffect`: with `Action="Mute"` the speaker icon mutes and the muted one unmutes.
* The clicks change the device the OSD shows. An application's volume (the OSD with its icon) takes no volume clicks.

* `Action`: `MediaPlayPause`, `MediaNext`, `MediaPrevious`, `MediaStop`, `MediaSeek`, `Mute`, `Volume`. Not needed inside
  the buttons, `MediaSeek` is the default inside `Progress` and `Volume` inside `Meter`.
* `Osd` (on a layer of the volume OSD): the OSD the button belongs to: `Volume`, `Balance`, `Eject`, `USB`, `Brightness`,
  `Battery`, `Notification` or `NetDrive`. Without it the button is on every one of them.
* `Grow`: skin pixels the area reaches past the element on every side, to make a small glyph or a thin bar easy to hit.
  `MediaSeek` still goes by the place along the bar itself: a click past one of its ends is the start or the end.
* `HoverColor`, `PressedColor`: every button gets a hand cursor, and with these the image of a button or of a layer
  takes that color while the pointer is over it and while it is pressed (through the image's own transparency, so its
  soft edge is kept). They take the forms of the skin's colorization: `#AARRGGBB`, `System`, an accent shade name or a
  number. `HoverColorDark`, `PressedColorDark` are used in a dark Windows color scheme; without them the light ones are.
* When buttons overlap, the media buttons come first, then the progress bar, the cover, and the layers from the top down.
  On the volume OSD the bar comes first, then the speaker icons, then the layers.
* Make a button at least about 24 x 24 pixels to hit, with `Grow` if its image is smaller.

Everything here is read from the skin's own `Skin.xml`; the copy the Skin Settings save in the user's profile only gives
the user's settings (speeds, motion, colorization, media keys).
