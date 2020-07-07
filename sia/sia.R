library(data.table)
library(stringr)
library(dplyr)
library(tidyr)
library(read.dbc)
library(openxlsx)
library(purrr)
library(janitor)
install.packages("plotly")
local <- getwd()
source(paste0(local,"/tb_nomes","/tb_nomes.R")) 
#source("tb_nomes/tb_nomes.R")
setwd(local)
dados <- readRDS(paste0(local,"/dados2003.rds"))

dados1 <- dados %>% 
  mutate(forma_organizacao = str_sub(PA_PROC_ID,1,6)) %>% 
  mutate(subgrupo = str_sub(PA_PROC_ID,1,4)) %>% 
  #group_by(PA_MVM, subgrupo, PA_PROC_ID) %>% 
  #summarise(total = sum(PA_QTDAPR)) %>% 
  left_join(tb_nome, by=c("subgrupo" = "codigo")) %>%
  left_join(tb_nome, by=c("forma_organizacao" = "codigo")) %>%
  left_join(tb_nome, by=c("PA_PROC_ID" = "codigo")) %>%
  spread(key = PA_MVM, value = total) %>% 
  mutate_at(vars(5: (length(arquivos)+4)), f) %>% 
  unite(col = Procedimento, c("PA_PROC_ID","nome.x")) %>% 
  select(1,3,2,4:(length(arquivos)+3)) %>% 
  ungroup()


documento_excel <- createWorkbook()

map(dados1$subgrupo %>% unique, addWorksheet,wb = documento_excel)
#coloca a planilha na aba do documento
gui <- split(dados1 %>% as.data.table(), by = c("subgrupo"))

gui <- map(gui,adorn_totals, where = c("row", "col"))

df <- data_frame( sheet = dados1$subgrupo %>% unique, x = gui )


pmap(df,writeData, wb = documento_excel)

saveWorkbook(documento_excel,"SIA_NOVO_RESUMO_GERAL.xlsx", TRUE) 





