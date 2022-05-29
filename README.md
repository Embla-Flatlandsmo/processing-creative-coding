# Creative coding projects
A collection of some of my personal projects done in processing.
## A brief overview:


Bezier Curve using de Casteljau's algorithm       | Marching Squares | Grass field (work in progress)
:-------------------------:|:-------------------------:|:-------------------------:
<img src="./bezierCurve/out.gif" width=300> | <img src="./marching_squares/marching_squares.png" width=300> | <img src="./grassField/grassField.png" width=300>


tubular-1             | growing-circles-1 | feathers-1
:-------------------------:|:-------------------------:|:-------------------------:
<img src="./tubular-1/frames/out.gif" width=300> | <img src="./growing-circles-1/frames/out.gif" width=300> | <img src="./feathers-1/frames/out.gif" width=300>


van-goghify                | spinning-square-1 | modular-grid (interactive)
:-------------------------:|:-------------------------:|:-------------------------:
<img src="./van-goghify/Van_Gogh_Lines.PNG" width=300> | <img src="./spinning-square-1/frames/out.gif" width=300> | <img src="./modularGrid/sample.svg" width=300>

hairy-brush (interactive)                | jellyfish | physics-water-surface (interactive)
:-------------------------:|:-------------------------:|:-------------------------:
<img src="./hairy-brush/Hairy_brush.JPG" width=300> | <img src="./jellyfish/Jellyfish.PNG" width=300> | <img src="./physics-water-surface/Water_surface.PNG" width=300>


<!-- for my own reference:
ffmpeg -r 60 -i frame_%03d.png -c:v libx264 -c:a aac -ar 44100 -pix_fmt yuv420p output.mp4

ffmpeg -f image2 -i frame_%3d.png -vf "setpts=0.5*PTS" out.gif


Alternatively (this might make color correct better):

ffmpeg -i frame_%03d.png -vf palettegen palette.png

then

ffmpeg -i frame_%03d.png -i palette.png -lavfi paletteuse video.gif

-->