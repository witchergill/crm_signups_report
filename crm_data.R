#loading packages

require(tidyverse)
require(plyr)
require(quantmod)
require(googledrive)
require(googlesheets4)
require(httr)
require(rvest)

googledrive::drive_auth(email = 'ap.kheloyaar@gmail.com',cache  = '.secretsap')
googlesheets4::gs4_auth(token = googledrive::drive_token())

success=T
while(success){
  assign('looping',TRUE,envir = .GlobalEnv)
  tryCatch(assign('data.bizz',content(GET(url = str_c("https://backend.lead-crm.online/handle-leads-api?from=",Sys.Date()-7,"&to=",Sys.Date()))),envir = .GlobalEnv),error=function(e){
    Sys.sleep(60)
    print('error')
    assign('looping',FALSE,envir = .GlobalEnv)
    
  })
  
  if(looping){
    assign('success',FALSE)
  }
}

data.bizz$`Lead Entry Date`<-as.Date(str_c(str_sub(data.bizz$`Lead Entry Date`,-4,-1),"-",str_sub(data.bizz$`Lead Entry Date`,4,5),"-",str_sub(data.bizz$`Lead Entry Date`,1,2)))
data.bizz$`Lead Covered Date`<-as.Date(str_c(str_sub(data.bizz$`Lead Covered Date`,-4,-1),"-",str_sub(data.bizz$`Lead Covered Date`,4,5),"-",str_sub(data.bizz$`Lead Covered Date`,1,2)))

# data<-data[!is.na(data$`Client Name`),]

success=T
while(success){
  looping=T
  tryCatch(range_write("1ev7E07C-l8-C29xhpRJ58EflOuFuIDa7qPyB8hQLjro",data = data.bizz,reformat = F,col_names = T,range = "A:M",sheet = "data.bizz"),error=function(e){
    Sys.sleep(5)
    print('error')
    assign('looping',FALSE,envir = .GlobalEnv)
  })
  if(looping){
    success=F
  }
}

while(T){
  
  #loading cummulative data stored in local .csv file
  #old.data<-read.csv('crm.cummulative.csv')[,-1]
  
  
  #retrieving the data from the endpoint of crm
  #using str_c() to dynamically create a string for endpoint which only extract data of today's date
  
  #for data.biz
  #for data.games
  
  success=T
  while(success){
    assign('looping',TRUE,envir = .GlobalEnv)
    tryCatch(assign('data.games',content(GET(url = str_c("https://backend.lead-crm-games.online/handle-leads-api?from=",Sys.Date()-7,"&to=",Sys.Date()))),envir = .GlobalEnv),error=function(e){
      Sys.sleep(60)
      print('error')
      assign('looping',FALSE,envir = .GlobalEnv)
      
    })
    
    if(looping){
      assign('success',FALSE)
    }
  }
  
  data.games$`Lead Entry Date`<-as.Date(str_c(str_sub(data.games$`Lead Entry Date`,-4,-1),"-",str_sub(data.games$`Lead Entry Date`,4,5),"-",str_sub(data.games$`Lead Entry Date`,1,2)))
  data.games$`Lead Covered Date`<-as.Date(str_c(str_sub(data.games$`Lead Covered Date`,-4,-1),"-",str_sub(data.games$`Lead Covered Date`,4,5),"-",str_sub(data.games$`Lead Covered Date`,1,2)))


  
  
  success=T
  while(success){
    looping=T
    tryCatch(range_write("1ev7E07C-l8-C29xhpRJ58EflOuFuIDa7qPyB8hQLjro",data = data.games,reformat = F,col_names = T,range = "A:M",sheet = "data.games"),error=function(e){
      Sys.sleep(5)
      print('error')
      looping=T
    })
    if(looping){
      success=F
    }
  }
  
  
 # write.csv(rbind(old.data,new.data),file = 'crm.cummulative.csv')
  
  cat("\n\n Waiting to write data \n\n")
  Sys.sleep(3*60)
  
  
}

#personal token number of github
#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

#writing the files to the local database  
#yes this is working absolutely fine
write_xlsx(data.bizz,'bizz.data (1st jul to 30jul).xlsx')
write_xlsx(data.games,'games.data (1st jul to 30jul).xlsx')

  
