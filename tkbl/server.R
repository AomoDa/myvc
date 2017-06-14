
source('./etl.R')
library(shiny)
library(ggplot2)
library(reshape)
library(plyr)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$did_summ_t1 <- renderTable({
    mydata <- sql_query(tb = 'tkbl_rpt_block_did_summ_day',
                        from_ds =input$dr1[1],
                        end_ds =input$dr1[2])
    agg_f(tb = mydata,val_index = 3:5,g_index = 14)
  })
  
  output$did_summ_p1 <- renderPlot({
    mydata <- sql_query(tb = 'tkbl_rpt_block_did_summ_day',
                        from_ds =input$dr1[1],
                        end_ds =input$dr1[2])
    mydata$num_did_out_day <- -mydata$num_did_out_day
    data_ok <- agg_f(tb = mydata,
                     val_index = 3:5,
                     g_index =14 )
    data_ok$ds <- as.Date(data_ok$ds)
    data_plot <- melt(data_ok,id.vars = 'ds')
    data_plot$value <- as.numeric(as.character(data_plot$value))/10000
    ggplot(data=data_plot,aes(x=ds,weight=value,fill=variable))+
      geom_bar()+
      theme_bw()+
      labs(y='',title='Device trend (units: ten thousand)')
  })
  
  
  
  output$ip_summ_t1 <- renderTable({
    mydata <- sql_query(tb = 'tkbl_rpt_block_ip_summ_day',
                        from_ds =input$dr1[1],
                        end_ds =input$dr1[2])
    agg_f(tb = mydata,val_index = 3:5,g_index = 14)
  })
  
  output$ip_summ_p1 <- renderPlot({
    mydata <- sql_query(tb = 'tkbl_rpt_block_ip_summ_day',
                        from_ds =input$dr1[1],
                        end_ds =input$dr1[2])
    mydata$num_ip_out_day <- -mydata$num_ip_out_day
    data_ok <- agg_f(tb = mydata,
                     val_index = 3:5,
                     g_index = 14)
    data_ok$ds <- as.Date(data_ok$ds)
    data_plot <- melt(data_ok,id.vars = 'ds')
    data_plot$value <- as.numeric(as.character(data_plot$value))/10000
    ggplot(data=data_plot,aes(x=ds,weight=value,fill=variable))+
      geom_bar()+
      theme_bw()+
      labs(y='',title='IP trend (units: ten thousand)')
  })
  
  output$cid_summ_t1 <- renderTable({
    mydata <- sql_query(tb = 'tkbl_rpt_block_cid_summ_day',
                        from_ds =input$dr1[1],
                        end_ds =input$dr1[2])
    mydata <- mydata[mydata$num_clk_day >=10000 & mydata$rate_ins_day<=0.00014,]
    mydata$rate_ins_day <- mydata$rate_ins_day * 1e4
    mydata$type <- 'Black Cid'
    head(mydata[,c(5,1:4,6)],10)
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      ff <- 'cid_data.csv'
      return(ff)
    },
    content = function(file) {
      mydata <- sql_query(tb = 'tkbl_rpt_block_cid_summ_day',
                          from_ds =input$dr1[1],
                          end_ds =input$dr1[2])
      mydata <- mydata[mydata$num_clk_day >=10000 & mydata$rate_ins_day<=0.00014,]
      mydata$rate_ins_day <- mydata$rate_ins_day * 1e4
      mydata$type <- 'Black Cid'
      write.csv(mydata, file)
    }
  )
  
output$cid_name <-  renderTable({  
    tb1 <- myfind(value = input$cidname)
    subset(tb1,subset = ty==input$cid_type)
    
  },rownames=F)
  
output$cidData <- downloadHandler(
  filename = function() {
    ff <- 'cid_info.csv'
    return(ff)
  },
  content = function(file) {
    write.csv(channel, file)
  }
)

#----------did

  output$r_did_p1 <- renderPlot({
    mydata <- sql_query(tb = 'tkbl_rpt_block_did_summ_day',
                        from_ds =input$r_did_dr[1],
                        end_ds =input$r_did_dr[2])
    if(input$r_did_cid!=-1){
      cids=as.numeric(input$r_did_cid)
      mydata <- mydata[mydata$cid==cids,]
    }
    p_data <- agg_f(tb = mydata,
                    val_index = 6:9,
                    g_index = 14)
    p_data[,2] <- as.numeric(as.character(p_data[,2]))
    p_data[,3] <- as.numeric(as.character(p_data[,3]))
    p_data[,4] <- as.numeric(as.character(p_data[,4]))
    p_data[,5] <- as.numeric(as.character(p_data[,5]))
    pdata_all <- melt(p_data,id.vars = names(p_data)[1])
    pdata_all$ds <- as.Date(pdata_all$ds)
    ggplot(data=pdata_all,aes(x=ds,
                              weight=as.numeric(value),
                              fill=variable))+geom_bar()+theme_bw()
    })
 
  output$r_did_p2 <- renderPlot({
    mydata <- sql_query(tb = 'tkbl_rpt_block_did_summ_day',
                        from_ds =input$r_did_dr[1],
                        end_ds =input$r_did_dr[2])
    if(input$r_did_cid!=-1){
      cids=as.numeric(input$r_did_cid)
      mydata <- mydata[mydata$cid==cids,]
    }
    p_data <- agg_f(tb = mydata,
                    val_index = 10:13,
                    g_index = 14)
    p_data[,2] <- as.numeric(as.character(p_data[,2]))
    p_data[,3] <- as.numeric(as.character(p_data[,3]))
    p_data[,4] <- as.numeric(as.character(p_data[,4]))
    p_data[,5] <- as.numeric(as.character(p_data[,5]))
    pdata_all <- melt(p_data,id.vars = names(p_data)[1])
    pdata_all$ds <- as.Date(pdata_all$ds)
    ggplot(data=pdata_all,aes(x=ds,
                              weight=as.numeric(value),
                              fill=variable))+geom_bar()+theme_bw()
  })
  
  
  output$r_did_t1 <- renderTable({
    mydata <- sql_query(tb = 'tkbl_rpt_block_did_summ_day',
                        from_ds =input$r_did_dr[1],
                        end_ds =input$r_did_dr[2])
    if(input$r_did_cid!=-1){
      cids=as.numeric(input$r_did_cid)
      mydata <- mydata[mydata$cid==cids,]
    }
    agg_f(tb = mydata,
          val_index = 3:9,
          g_index = 14)
    })
  
  output$r_did_t2 <- renderTable({
    mydata <- sql_query(tb = 'tkbl_rpt_block_did_summ_day',
                        from_ds =input$r_did_dr[1],
                        end_ds =input$r_did_dr[2])
    if(input$r_did_cid!=-1){
      cids=as.numeric(input$r_did_cid)
      mydata <- mydata[mydata$cid==cids,]
    }
    agg_f(tb = mydata,
          val_index = c(3:5,10:13),
          g_index = 14)
  })
  
  #----------IP
  
  output$r_ip_t1 <- renderTable({
    mydata <- sql_query(tb = 'tkbl_rpt_block_ip_summ_day',
                        from_ds =input$r_ip_dr[1],
                        end_ds =input$r_ip_dr[2])
    if(input$r_ip_cid!=-1){
      cids=as.numeric(input$r_ip_cid)
      mydata <- mydata[mydata$cid==cids,]
    }
    agg_f(tb = mydata,
          val_index = 3:9,
          g_index = 14)
  })
  
  output$r_ip_t2 <- renderTable({
    mydata <- sql_query(tb = 'tkbl_rpt_block_ip_summ_day',
                        from_ds =input$r_ip_dr[1],
                        end_ds =input$r_ip_dr[2])
    if(input$r_ip_cid!=-1){
      cids=as.numeric(input$r_ip_cid)
      mydata <- mydata[mydata$cid==cids,]
    }
    agg_f(tb = mydata,
          val_index = c(3:5,10:13),
          g_index = 14)
  })
  
  output$r_ip_p1 <- renderPlot({
    mydata <- sql_query(tb = 'tkbl_rpt_block_ip_summ_day',
                        from_ds =input$r_ip_dr[1],
                        end_ds =input$r_ip_dr[2])
    if(input$r_ip_cid!=-1){
      cids=as.numeric(input$r_ip_cid)
      mydata <- mydata[mydata$cid==cids,]
    }
    p_data <- agg_f(tb = mydata,
                    val_index = 6:9,
                    g_index = 14)
    p_data[,2] <- as.numeric(as.character(p_data[,2]))
    p_data[,3] <- as.numeric(as.character(p_data[,3]))
    p_data[,4] <- as.numeric(as.character(p_data[,4]))
    p_data[,5] <- as.numeric(as.character(p_data[,5]))
    pdata_all <- melt(p_data,id.vars = names(p_data)[1])
    pdata_all$ds <- as.Date(pdata_all$ds)
    ggplot(data=pdata_all,aes(x=ds,
                              weight=as.numeric(value),
                              fill=variable))+geom_bar()+theme_bw()
  })
  output$r_ip_p2 <- renderPlot({
    mydata <- sql_query(tb = 'tkbl_rpt_block_ip_summ_day',
                        from_ds =input$r_ip_dr[1],
                        end_ds =input$r_ip_dr[2])
    if(input$r_ip_cid!=-1){
      cids=as.numeric(input$r_ip_cid)
      mydata <- mydata[mydata$cid==cids,]
    }
    p_data <- agg_f(tb = mydata,
                    val_index = 10:13,
                    g_index = 14)
    p_data[,2] <- as.numeric(as.character(p_data[,2]))
    p_data[,3] <- as.numeric(as.character(p_data[,3]))
    p_data[,4] <- as.numeric(as.character(p_data[,4]))
    p_data[,5] <- as.numeric(as.character(p_data[,5]))
    pdata_all <- melt(p_data,id.vars = names(p_data)[1])
    pdata_all$ds <- as.Date(pdata_all$ds)
    ggplot(data=pdata_all,aes(x=ds,
                              weight=as.numeric(value),
                              fill=variable))+geom_bar()+theme_bw()
  })
  
  
  
  
  output$p3 <- renderPlot({
    mydata <- sql_query2(tb = 'tkbl_rpt_fake_clk_day',
                         from_ds = input$d_clk_dr[1],
                         end_ds = input$d_clk_dr[2])
    appids=as.character(input$d_clk_appid)
    if(appids!='all'){
      mydata <- mydata[mydata$appid==appids,c(2:3,5:6,11)]
    }else{
      mydata <- mydata[,c(2:3,5:6,11)]
    }
    pdata <- agg_f(tb = mydata,val_index = 1:4,g_index = 5)
    pdata$ds <- as.Date(pdata$ds)
    pdata[,2] <- as.numeric(as.character(pdata[,2]))
    pdata[,3] <- as.numeric(as.character(pdata[,3]))
    pdata[,4] <- as.numeric(as.character(pdata[,4]))
    pdata[,5] <- as.numeric(as.character(pdata[,5]))
    ggplot(data=pdata,aes(x=ds))+
      geom_line(aes(y=num_clk_fake/num_clk_all),col=I('orange'))+
      geom_point(aes(y=num_clk_fake/num_clk_all),col=I('orange'))+
      labs(y='',title='red=balcklist ; blue=old_rules,orange=fake ')+theme_bw()+
      geom_line(aes(y=num_bl_only/num_clk_all),col=I('red'))+
      geom_point(aes(y=num_bl_only/num_clk_all),col=I('red'))+
      geom_line(aes(y=num_old_only/num_clk_all),col=I('blue'))+
      geom_point(aes(y=num_old_only/num_clk_all),col=I('blue'))
    })
  
  output$p4 <- renderPlot({
    mydata <- sql_query2(tb = 'tkbl_rpt_fake_ins_day',
                         from_ds = input$d_ins_dr[1],
                         end_ds = input$d_ins_dr[2])
    appids=as.character(input$d_ins_appid)
    if(appids!='all'){
      mydata <- mydata[mydata$appid==appids,c(2:3,5:6,11)]
    }else{
      mydata <- mydata[,c(2:3,5:6,11)]
    }
    pdata <- agg_f(tb = mydata,val_index = 1:4,g_index = 5)
    pdata$ds <- as.Date(pdata$ds)
    pdata[,2] <- as.numeric(as.character(pdata[,2]))
    pdata[,3] <- as.numeric(as.character(pdata[,3]))
    pdata[,4] <- as.numeric(as.character(pdata[,4]))
    pdata[,5] <- as.numeric(as.character(pdata[,5]))
    ggplot(data=pdata,aes(x=ds))+
      geom_line(aes(y=num_ins_fake/num_ins_all),col=I('orange'))+
      geom_point(aes(y=num_ins_fake/num_ins_all),col=I('orange'))+
      labs(y='',title='red=balcklist ; blue=old_rules,orange=fake ')+theme_bw()+
      geom_line(aes(y=num_bl_only/num_ins_all),col=I('red'))+
      geom_point(aes(y=num_bl_only/num_ins_all),col=I('red'))+
      geom_line(aes(y=num_old_only/num_ins_all),col=I('blue'))+
      geom_point(aes(y=num_old_only/num_ins_all),col=I('blue'))
    })
  

  
  output$t3 <- renderTable({
    mydata <- sql_query2(tb = 'tkbl_rpt_fake_clk_day',
                         from_ds = input$d_clk_dr[1],
                         end_ds = input$d_clk_dr[2])
    appids=as.character(input$d_clk_appid)
    if(appids!='all'){
      mydata <- mydata[mydata$appid==appids,c(2:3,4,5:6,11)]
    }else{
      mydata <- mydata[,c(2:3,4,5:6,11)]
    }
    agg_f(tb = mydata,val_index = 1:5,g_index = 6)
    
  })
  
  output$t4 <- renderTable({
    mydata <- sql_query2(tb = 'tkbl_rpt_fake_ins_day',
                         from_ds = input$d_ins_dr[1],
                         end_ds = input$d_ins_dr[2])
    appids=as.character(input$d_ins_appid)
    if(appids!='all'){
      mydata <- mydata[mydata$appid==appids,c(2:3,4,5:6,11)]
    }else{
      mydata <- mydata[,c(2:3,4,5:6,11)]
      }
    agg_f(tb = mydata,val_index = 1:5,g_index = 6)
    
  })
  


  output$app_info <- renderTable({
    appids=as.character(input$d_query_appid)
    appids=ifelse(input$d_query_appid=='',
                  '064f86cbdc474d65df4e9fd47f58213b',
                  appids)
    myfind_app(value = appids)
    
  })
  
  output$xp1 <- renderPlot({ 
    cds <- as.character(input$cid_ds)
    mydata <- sql_query(tb = 'tkbl_rpt_fake_clk_cid_day',
                        from_ds = cds,
                        end_ds = cds)
    p <- mydata[,3]/mydata[,2]
    a=cut(p,seq(0,1.05,by = 0.05),ordered_result = T,right = F)
    par(las=2)
    barplot(prop.table(table(a)),main='Click Fake Rate')
    })
  
  output$xp2 <- renderPlot({ 
    cds <- as.character(input$cid_ds)
    mydata <- sql_query(tb = 'tkbl_rpt_fake_ins_cid_day',
                        from_ds = cds,
                        end_ds = cds)
    p <- mydata[,3]/mydata[,2]
    a=cut(p,seq(0,1.05,by = 0.05),ordered_result = T,right = F)
    par(las=2)
    barplot(prop.table(table(a)),main='Install Fake Rate')
  })
  
  
  output$cid_clk <- downloadHandler(
    filename = function() {
      ff <- 'cid_clk.csv'
      return(ff)
    },
    content = function(file) {
      cds <- as.character(input$cid_ds)
      mydata <- sql_query(tb = 'tkbl_rpt_fake_clk_cid_day',
                          from_ds = cds,
                          end_ds = cds)
      mydata$rate <- mydata[,3]/mydata[,2]
      write.csv(mydata, file)
    }
  )
  
  output$cid_ins <- downloadHandler(
    filename = function() {
      ff <- 'cid_clk.csv'
      return(ff)
    },
    content = function(file) {
      cds <- as.character(input$cid_ds)
      mydata <- sql_query(tb = 'tkbl_rpt_fake_ins_cid_day',
                          from_ds = cds,
                          end_ds = cds)
      mydata$rate <- mydata[,3]/mydata[,2]
      write.csv(mydata, file)
    }
  )
  
})
