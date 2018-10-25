## Making a hex sticker for polyglot
## Image under license: CC0 Public Domain
library(hexSticker)
library(magick)
library(dplyr)

hexSticker::sticker("https://www.publicdomainpictures.net/pictures/160000/velka/male-graduate-silhouette-clipart.jpg",
                    package="",
                    spotlight = FALSE,
                    h_size = 1.5,
                    h_color = "black",
                    h_fill = "white",
                    p_size=0.5, p_y = 0.1,
                    s_x=1, s_y= 1.00, s_width=0.54,
                    url="polyglot",
                    u_size = 4,
                    u_y = 0.2,
                    u_x = 1.05,
                    u_color = "black",
                    filename="man/figures/polyglot.png")

graduate <- magick::image_read("man/figures/polyglot.png")
magick::image_scale(graduate, "130") %>%
  magick::image_write(path = "man/figures/logo.png", format = "png")

