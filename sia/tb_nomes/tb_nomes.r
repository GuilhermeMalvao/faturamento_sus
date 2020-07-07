library(data.table)
library(stringr)
library(dplyr)
library(tidyr)
library(read.dbc)
setwd(paste0(local,"/tb_nomes") )
arquivos <- grep(".txt",list.files(),value = T) %>% sort(d = T) 
#arquivos posicao impar contem os layouts das respectivas tabelas
#arquivos posicaoo par contem as tabelas

for(i in seq(1,length(arquivos),2 ) ){
  #le o arquivo_layout.txt e armazena com o nome que ele veio
  assign(arquivos[i],read.csv(arquivos[i],header = T) )
  
  #verifica quantas colunas tem o arquivo da tabela
  tamanho <- eval(parse(text = paste0(arquivos[i],"$Tamanho %>% length" ))) 
  
  #le o arquivo.txt e de acordo com os tamnhos de cada coluna e armazena com o nome que ele veio
  assign(arquivos[i+1],
         read.fwf(arquivos[i+1],
                  colClasses = "character",
                  widths = eval(parse(text = paste0(arquivos[i],"$Tamanho[1:",tamanho,"]" ))) 
         ) 
  )
  # eval(parse(text = paste0(arquivos[i+1]," <- ", arquivos[i+1]," %>% mutate(V1 = paste0(0,V1))") ))
  
  eval(parse(text = paste0("names(",arquivos[i+1],") <-", arquivos[i],"$Coluna ") ))
}


tb_procedimento.txt <- tb_procedimento.txt %>% 
  select(1,2)
names(tb_procedimento.txt) <- c("codigo","nome")


tb_forma_organizacao.txt <- tb_forma_organizacao.txt %>% 
  unite(nome , CO_GRUPO, CO_SUB_GRUPO, CO_FORMA_ORGANIZACAO, sep = "" ) %>% 
  select(-3)

names(tb_forma_organizacao.txt) <- c("codigo","nome")


tb_sub_grupo.txt <- tb_sub_grupo.txt %>% 
  unite(nome , CO_GRUPO, CO_SUB_GRUPO, sep = "" ) %>% 
  select(-3)

names(tb_sub_grupo.txt) <- c("codigo","nome")

tb_grupo.txt <- tb_grupo.txt %>% 
  select(-3)

names(tb_grupo.txt) <- c("codigo","nome")


tb_financiamento.txt <- tb_financiamento.txt %>% 
  select(-3)

tb_nome <- bind_rows(tb_procedimento.txt, tb_forma_organizacao.txt, tb_sub_grupo.txt, tb_grupo.txt)

rm(list = c(grep("lay",ls(),v=T),"tb_procedimento.txt", "tb_forma_organizacao.txt", "tb_sub_grupo.txt","tb_grupo.txt"))


