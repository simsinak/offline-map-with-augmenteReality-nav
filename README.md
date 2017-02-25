#Augmented Reality Navigation
It works based on offline maps, which we have used MapBox for it.
___
It uses augmented reality for showing around POIs by using AR SDK
___
Also it shows an augmented reality-based video by help of Vuforia SDK
___
*NOTE:* _Compile the project on iphone 5/5s, not the simulator. unless you will get error
___
#Instruction
You can create your offline maps by following [osm-bright](https://github.com/mapbox/osm-bright) project
For reduceing the project size, the offline map file has been removed from the project. so put your maps with *mbTiles* extension to the project folder and in the *viewcController.m* change the _iran-shiraz-1_   in *line 21* to your mbtile map name.

RMMBTilesSource *content=[[RMMBTilesSource alloc]initWithTileSetResource:@"iran-shiraz-1"];

Then in the _build phase setting_ add the map to *Copy bundle resources*.

![pic1](http://www.axgig.com/images/83807328792515708386.png)
![pic2](http://www.axgig.com/images/20543710678006116589.png)
![pic3](http://www.axgig.com/images/77851986116962818458.png)
![pic4](http://www.axgig.com/images/47292886495040493761.png)
