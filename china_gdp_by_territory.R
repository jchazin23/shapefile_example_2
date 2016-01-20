library(ggmap)
library(ggplot2)
library(viridis)
library(maptools)
library(plyr)

gdp = read.csv("china_gdp_2014.csv")
gdp$provinces = as.character(gdp$provinces)
gdp$provinces = gsub("Inner Mongolia","Nei Mongol",gdp$provinces)
gdp$provinces = gsub("Tibet","Xizang",gdp$provinces)

map = readShapePoly("CHN_adm3.shp")
map$NAME_1 = gsub("Xinjiang Uygur","Xinjiang",map$NAME_1)
map$NAME_1 = gsub("Ningxia Hui","Ningxia",map$NAME_1)

area.map = fortify(map, region = "NAME_1")
colnames(area.map)[6] = "provinces"

map.final = join(gdp,area.map, by = "provinces")
# if shapes become mixed up use join instead of merge, see
# http://stackoverflow.com/questions/29614972/ggplot-us-state-map-colors-are-fine-polygons-jagged-r

colnames(map.final)[4] = "Nom"
map.final = map.final[which(map.final$provinces != 'Mainland China'),]

svg("China.svg",width=11.25,height=7.875)
ggplot(map.final, aes(x = long, y = lat, group = group, fill = Nom)) +
  geom_polygon(color = "black", size = 0.25, aes(group = group)) + theme_minimal() +
  ylab('Latitude (Deg)') + xlab('Longitude (Deg)') + ggtitle("Nominal GDP Per Capita by Chinese Administrative Division") +
  scale_fill_viridis(name = "GDP Per Capita \n (USD)")
dev.off()
