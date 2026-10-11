# Skins: colorization, previews and tray icons in SVG

This page is for skin authors. It describes how Volume2 colors an OSD skin, how the skin lists show a skin's preview, and
how a tray skin draws sharp at every tray size. The pictures themselves can be files or parts of the skin's picture
sheet, see [Skins - Picture sheet](Skins%20-%20Picture%20sheet.md); the media OSD and the buttons are in
[OSD Skin - Media OSD and Buttons](OSD%20Skin%20-%20Media%20OSD%20and%20Buttons.md).

## Colorization (OSD skins)

The user turns colorization on in the Skin Settings of a skin (**Use Colorization**) and picks a color (**Select Color**)
or the Windows color (**Use System Color Scheme**). A skin gives the defaults in its `Skin.xml`, and marks which of its
pictures take the color:

```xml
<OSD>
  <Colorization>true</Colorization>
  <ColorizationColor>System</ColorizationColor>
  ...
</OSD>
<Background Colorize="true"/>
<Meter X="63" Y="58" Orientation="BitMoveRight" Min="0" Max="225" Colorize="true"/>
<MeterEffect Enable="true" ... Colorize="true"/>
<Layers>
  <Layer Enable="true" Image="Volume_Parts.svg" X="39" Y="21" LayerIndex="0" Colorize="true"/>
</Layers>
```

* `Colorization`: whether the skin is colored at all, until the user changes it.
* `ColorizationColor`: `#AARRGGBB`; `-1` for the Windows colorization color; `System` for the accent shade Windows 11 uses
  in its own flyouts (`AccentDark1` in light mode, `AccentLight2` in dark mode); an accent shade by name, `AccentLight3`
  ... `Accent` ... `AccentDark3`.
* `Colorize="true"` on `Background`, `Meter`, `MeterMute`, `MeterEffect`, `MeterMuteEffect`, `PeakMeter` or a `Layer`: that
  picture takes the color. The glass picture (`Glass`) is never colored.

### How the color is applied

Volume2 first looks at the colors of the skin's art: the background picture (`Back`), or the meter (`Meter`) when the
background has no color of its own. The color its most colorful pixels share is the skin's **own color**.

* **Colored art** (a blue background, an orange bar, a green logo): every colored pixel takes the hue of the chosen
  color. The skin's own color becomes exactly the chosen color; lighter and darker parts stay lighter and darker; greys,
  white and black stay as they are. Art in several colors (a multicolored logo) comes out in shades of the one color.
* **Grey art** (white, grey or black only, with no colored pixels): the picture is tinted with the chosen color, as
  skins have always been (each pixel multiplied by the color, so white becomes the color and grey a darker shade of it).
* **A grey chosen color** (`#808080` and the like) tints every skin, also colored art: a grey color only makes it darker.

![Six skins as drawn, then colorized in orange, magenta, green and grey](Images/Colorize%20-%20colors.png)

Before this change all art was tinted. On colored art the chosen color mixed with the skin's own color, so a blue skin
colored orange came out dark green, and a dark skin nearly black:

![The same skins in orange: tinted before, now](Images/Colorize%20-%20before%20and%20after.png)

`-1`, `System` and the accent shades follow the Windows color; `System` also follows its light or dark mode:

![System in light and dark mode](Images/Colorize%20-%20System%20in%20light%20and%20dark%20mode.png)

### Drawing art that colorizes well

* Draw the parts that should take the color in **one color** of your choice, in the background (or the meter), at the
  lightness the chosen color should have there. Windows 10 draws its background `#005A9E`: that blue becomes exactly the
  chosen color, its lighter fill and track lighter shades of it.
* Draw what should stay neutral in **grey or white**: glass, chrome, plates behind the text, a white thumb. They keep
  their look whatever the color, as the glass of Aero Glass and the frame of Candy Apple Red do.
* Pale colors count as grey: a pixel needs some saturation (more than a beige `#D4D0C8`) to count as colored. Art where
  fewer than one pixel in two hundred is colored counts as grey art.
* For a skin that should be tinted as a whole, draw it in grey (Windows 10 v2, Classic Shell's frame).
* `Glass` is drawn over the meter and never colored. A part that must match a colored background, such as a mask that
  hides the moving meter, belongs in a layer with `Colorize="true"` and `LayerIndex="2"` (drawn after the meter), not in
  `Glass`; otherwise a tinted background shows the mask as an untinted block. Windows 10 Small does this for the top of
  its bar:

  ```xml
  <Layers>
    <Layer Enable="true" Image="Meter_Mask.svg" X="27" Y="0" LayerIndex="2" Colorize="true"/>
  </Layers>
  ```

* The colors written in `Skin.xml` (text, progress bar, hover and pressed colors) are not changed by colorization. Use
  `System` or an accent shade name there for a color that follows Windows.
* Opaque white, `#FFFFFFFF`, is kept as `#FFFEFEFE` (the difference cannot be seen): Volume2 keeps colors as numbers,
  and the numbers `-1` to `-9` stand for `-1`, the accent shades and `System`.

## Previews (OSD and meter skins)

The skin lists show a preview of every skin. Volume2 takes the first of:

1. `Preview.png` in the skin's folder,
2. `Preview.svg` in the skin's folder,
3. the `Preview` part of the skin's `Skin.svg`.

The preview is fitted into the list's box, keeping its proportions: 94 x 54 pixels in the OSD skin list, scaled with the
display (141 x 81 at 150 %), and 94 x 56 in the meter skin list. A smaller preview is not enlarged past the display
scaling. A preview is drawn when its row is first shown, so a long list opens fast.

Draw the preview in SVG, at 94 x 54 or in that proportion: it is then drawn at the size it is shown, sharp at any display
scaling. A `Preview.png`, or a PNG kept inside the sheet (`<image href="data:image/png;base64,..."/>`), is scaled and is
soft at 150 %:

![An SVG preview at 150 %: stretched before, drawn at its size now](Images/Preview%20-%20SVG%20drawn%20for%20the%20list.png)

## Tray skins in SVG

A tray skin (`Skins\<name>`) is made of these pictures, each with a mute version shown while the sound is muted:

| Picture | Mute version | Shows |
|---------|--------------|-------|
| `Back` | `Back_Mute` | the icon behind the meter or the digits |
| `Meter` | `Meter_Mute` | the volume as frames of a strip, one frame per step |
| `Digits` | `Digits_Mute` | the digits 0 to 9 for the volume in percent |
| `Digits_100` | `Digits_Mute_100` | 100 % as one picture |

The tray icon is 16, 20, 24 or 32 pixels, with the display scaling. A picture for one size has its name with `_20`,
`_24` or `_32` (`Back_24`, `Meter_Mute_32`); the 16 pixel one has none. For each picture and its mute version together:

* a size with its own pictures uses them, pixel for pixel;
* a size without them uses the plain `Back.svg` / `Meter.svg`... drawn at that size, so one SVG serves every size;
* a plain PNG is the 16 pixel picture: a skin with no picture for the tray's size is drawn at 16 pixels and stretched.

So a skin can draw everything once in SVG and look sharp at every size, or give hand-made pixel-exact pictures for the
sizes where the drawn ones are not good enough (thin lines, small digits). The pictures can all live in the skin's
`Skin.svg`:

```xml
<svg id="Meter" x="0" y="0" width="16" height="784" viewBox="0 0 16 784"> ...49 frames of 16 x 16... </svg>
<svg id="Meter_Mute" x="26" y="0" width="16" height="784" viewBox="0 0 16 784"> ... </svg>
<svg id="Meter_20" x="52" y="0" width="20" height="980" viewBox="0 0 20 980"> ...49 frames of 20 x 20... </svg>
<svg id="Meter_Mute_20" x="82" y="0" width="20" height="980" viewBox="0 0 20 980"> ... </svg>
```

* A meter strip holds its frames one under another, each a square of the icon size; the skin's `meterMax` is the number of
  frames minus one (49 frames, `meterMax` 48).
* A frame should change visibly from one step to the next: about 24 to 48 steps are enough for a 16 pixel icon, more
  frames only repeat the same picture.
* For a pixel-exact picture, draw on whole pixels (`x`, `y`, `width`, `height` in whole numbers, no strokes on half
  pixels): Volume2 draws a sized SVG part at exactly its size.
