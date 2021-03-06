# modular-grid
A grid that renders svg tiles based on its neighbors. Drag the mouse to draw some tiles and see how the rendered tiles change!
My implementation of [Generative Design](http://www.generative-gestaltung.de/2/) P.2.3.6 with some tweaks of my own.

## Settings
I have provided a few settings. The size of the window is determined `tileSize`, `xNumTiles` and `yNumTiles`. The setting names are not case sensitive but needs to be delimited by `=`. This is the default configuration:
```
tileSize=20
xNumTiles=10
yNumTiles=10
templateName=spaceInvader.png
```
### **Some notes:**
* `tileSize`, `xNumTiles` and `yNumTiles` are integers. Trying to put float values might cause the software to crash.
* If a template of the name given by `templateName` exists in the data folder, `xNumTiles` and `yNumTiles` will be set by the width and height of the picture.
* If you want to make your own tiles, simply replace the SVG files in data. It is important that the tiles.

## Making your own tiles
The `data` folder contains the svg-files used in the project. They must be named with two letter suffixed, i.e. `bridge_00.svg`, `bridge_01.svg` etc. They must be named sequentially, as the program keeps trying to load tiles incrementally until it cannot find a file. They need to be provided in the following rotations, otherwise it will end up looking wrong:

Bridge                     |        Corner             | End
:-------------------------:|:-------------------------:|:-------------------------:
<img src="./data/bridge_00.svg" width=50> | <img src="./data/corner_00.svg" width=50> | <img src="./data/end_00.svg" width=50>
**Intersection**           |        **Island**             | **T**
<img src="./data/intersection_00.svg" width=50> | <img src="./data/island_00.svg" width=50> | <img src="./data/T_00.svg" width=50>
## Controls
| Key | Description |
--- | --- |
**p** | Change from pixel view to module view
**s** | When in pixel view: Save the pixel map as a .png (in root, named `pixelMap.png`). When in module view: save the picture as a .svg (given by `frame-####.svg`)
**c** | clear canvas
**r** | reflect the currently drawn tiles (only draws new tiles, does not erase any)
**m** | start mirroring drawing
**l** | load template image
**v** | pick new random tiles
**Ctrl-z** | Undo. Max 1 step. Undoing twice will redo.

<img src="./sample.svg" width=500>

## Implementation details
`infoGrid.pde` keeps track of information about the grid. Most importantly, it keeps track of where its neighbors are, and also whether or not the current tile is active.