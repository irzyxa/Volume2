# Text OSD: the media text and its buttons

With the Text style OSD, the media keys show the playing track as text, with the
Previous, Play/Pause and Next buttons in front of it. This page describes the text it shows and how to move or hide the
buttons.

## Where the text is set

The text is `OsdHintMediaInfo` in the `[OSD]` section of `Config.ini` (`%AppData%\Volume2\Config.ini`). Close Volume²
before editing the file: it saves its settings when it exits and would write the old text back. The default is
`%a - %t%NL%MediaButtons`, the track on one line and the buttons under it.

```ini
[OSD]
OsdHintMediaInfo=%a - %t%NL%MediaButtons
```

![Buttons on their own line](Images/Text%20OSD%20-%20media,%20buttons%20on%20their%20own%20line.png)

## Codes

* `%t` the title, `%a` the artist, `%n` the player, `%e` elapsed time, `%d` length of the track, `%r` time left, `%p`
  percent played, `%%` a percent sign. A time is empty for a player that reports no length (a live stream).
* The volume OSD's codes: `%V` the volume, `%A` the volume from 0 to 65535, `%S` on or off, `%D` the device, `%DF` the
  device's full name. The codes are case-sensitive: `%a` is the artist and `%A` the volume, `%d` the length and `%D` the
  device.
* `%NL` a new line. Lines are centered on the OSD.
* `%C(x,y)` puts its line at `x`, `y` pixels from the top left corner of the OSD (`y` is the top of the line). Every
  line can have its own; a line without one goes under the line before it.

![Two lines](Images/Text%20OSD%20-%20media,%20two%20lines.png)

## Buttons

With button codes, only the buttons written in the text are shown, each where its code is. A text without any button
code, such as `%a - %t`, shows the three buttons in front of its first line:

![One line](Images/Text%20OSD%20-%20media,%20one%20line.png)

| Code | Shows |
|---|---|
| `%MediaButtons` | Previous, Play/Pause and Next, in a row |
| `%MediaPrev` | Previous |
| `%MediaPlay` | Play/Pause: play while the track is paused, pause while it plays |
| `%MediaNext` | Next |

* A code stands for a button in the line, as wide as the button: put a space between it and the text next to it.
* A line with buttons and without `%C` is centered as a whole, buttons included.
* `%C(x,y)` places a line with buttons like any other line, so a button can have a line, and a place, of its own.
* A button written twice is shown once, where it is first.
* A button the player cannot use now, such as Previous on the first track, is shown dimmed.

`%MediaPlay %a - %t`, only Play/Pause:

![Only play](Images/Text%20OSD%20-%20media,%20only%20play.png)

`%MediaPrev %t %MediaNext`, Previous and Next around the title:

![Previous and next around the title](Images/Text%20OSD%20-%20media,%20previous%20and%20next%20around%20the%20title.png)

`%C(12,14)%a%NL%C(12,62)%t - %e%NL%C(362,42)%MediaButtons`, the track on the left and the buttons on the right (the
pointer is over Next):

![Placed with C](Images/Text%20OSD%20-%20media,%20placed%20with%20C.png)

A line too long for the OSD is cut with an ellipsis; a button written after the cut is not shown, so give a long title
a line of its own or place the buttons with `%C`.

The buttons are as big as the text (1.4 times the font size, at least 24 pixels). They take the text's color, and its
outline color and width when Text Outline is on. On the bar a button under the pointer gets a light box, without the
bar a faint one in the text's color.
