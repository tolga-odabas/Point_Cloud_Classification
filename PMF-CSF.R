# Gerekli k??t??phaneleri y??kleme
library(lidR)
library(ggplot2)

# LAS dosyas??n?? y??kleme
las_file <- "G:/Doktora_Bitirme_TEZ/151124/Atabari-L1-P1.las"  # LAS dosyas??n??n yolu
las <- readLAS(las_file, select = "xyzrn")

# LAS dosyas??n?? kontrol etme
if (is.empty(las)) {
  stop("LAS dosyas?? bo??!")
}

# PMF parametreleri (y??ksek e??imli alanlar i??in optimize edilmi??)
pmf_params <- pmf(ws = c(3, 6, 12, 18), th = c(0.4, 0.5, 0.6, 0.6))

# PMF ile zemin s??n??fland??rmas??
las <- classify_ground(las, algorithm = pmf_params)

# Zemin ve zemin ??st?? noktalar?? ay??rma
ground <- filter_poi(las, Classification == 2)      # Zemin noktalar??
non_ground <- filter_poi(las, Classification != 2)  # Zemin ??st?? noktalar

output_path <- "G:/Doktora_Bitirme_TEZ/151124/PMF/PMF-non_ground.las"
writeLAS(non_ground, output_path)

# Sonu??lar?? g??rselle??tirme
plot(las, color = "Classification", size = 2)



# ???? CSF Algoritmas??n?? uygulama (%40 e??ime sahip ormanl??k alan i??in)
csf_params <- csf(
  sloop_smooth = TRUE,      # E??imi d??zle??tirme
  class_threshold = 1.0,    # S??n??fland??rma e??i??i (??nerilen: 0.5 - 1.5)
  cloth_resolution = 0.75,  # Kuma?? ????z??n??rl?????? (??nerilen: 0.5 - 1.0 m)
  rigidness = 2,            # Kuma?? sertli??i (??nerilen: 1 - 3)
  time_step = 0.65          # Zaman ad??m?? (??nerilen: 0.5 - 0.8)
)

# CSF algoritmas?? ile zemin ve zemin olmayan noktalar?? tespit etme
las_classified <- classify_ground(las, csf_params)

# Zemin ve zemin ??st?? noktalar?? ay??rma
ground <- filter_poi(las_classified, Classification == 2)      # Zemin noktalar??
non_ground <- filter_poi(las_classified, Classification != 2)  # Zemin ??st?? noktalar

output_path <- "G:/Doktora_Bitirme_TEZ/151124/CSF/CSF-non_ground.las"
writeLAS(non_ground, output_path)

