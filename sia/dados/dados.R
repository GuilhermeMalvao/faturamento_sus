library(data.table)
library(stringr)
library(dplyr)
library(tidyr)
library(read.dbc)

download.dbc2FTP<-function(UF,ANO,MES){
  arquivo<-paste0("PA",UF,ANO,MES,".dbc")
  url<-paste0("ftp://ftp.datasus.gov.br/dissemin/publicos/SIASUS/200801_/dados/",arquivo)
  download.file(url,destfile = arquivo,mode="wb")
}

####BAIXA O ARQUIVO NO SITE DO DATASUS#### http://www2.datasus.gov.br/DATASUS/index.php?area=0901
uf <- "DF"
ano <- "20"
mes <- "01"
download.dbc2FTP(uf,ano,mes)

arquivos <- grep("PA",list.files(),value = T) 

arq <- arquivos %>% last()

comp_anterior <- arquivos %>% nth(-2) %>% str_sub(5,8)

comp_atual <- arquivos %>% nth(-1) %>% str_sub(5,8)

dados <- readRDS(paste0("dados",comp_anterior,".rds"))

arq <- grep("PA",list.files(),value = T) %>% last()
arq

dados_aux <- read.dbc(arq) %>%
  filter(PA_CODUNI == "0010510") %>% 
  select(PA_MVM,PA_TPFIN,PA_PROC_ID, PA_QTDAPR,PA_VALAPR)

dados <- bind_rows(dados, dados_aux)
rm(dados_aux)

saveRDS(dados,paste0("dados",comp_atual,".rds"))

file.remove(paste0("dados",comp_anterior,".rds"))
file.remove(paste0("PADF",comp_anterior,".dbc"))
