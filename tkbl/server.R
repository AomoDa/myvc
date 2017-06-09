
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
    agg_f(tb = mydata,val_index = 3:5,g_index = 6)
  })
  
  output$did_summ_p1 <- renderPlot({
    mydata <- sql_query(tb = 'tkbl_rpt_block_did_summ_day',
                        from_ds =input$dr1[1],
                        end_ds =input$dr1[2])
    mydata$num_did_out_day <- -mydata$num_did_out_day
    data_ok <- agg_f(tb = mydata,
                     val_index = 3:5,
                     g_index = 6)
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
    agg_f(tb = mydata,val_index = 3:5,g_index = 6)
  })
  
  output$ip_summ_p1 <- renderPlot({
    mydata <- sql_query(tb = 'tkbl_rpt_block_ip_summ_day',
                        from_ds =input$dr1[1],
                        end_ds =input$dr1[2])
    mydata$num_ip_out_day <- -mydata$num_ip_out_day
    data_ok <- agg_f(tb = mydata,
                     val_index = 3:5,
                     g_index = 6)
    data_ok$ds <- as.Date(data_ok$ds)
    data_plot <- melt(data_ok,id.vars = 'ds')
    data_plot$value <- as.numeric(as.character(data_plot$value))/10000
    ggplot(data=data_plot,aes(x=ds,weight=value,fill=variable))+
      geom_bar()+
      theme_bw()+
      labs(y='',title='IP trend (units: ten thousand)')
  })
  
  output$cid_summ_t1 <- renderTable({
    cids <- ifelse(is.na(input$cid_summ),
                   514,
                   as.numeric(input$cid_summ))
    mydata <- sql_query(tb = 'tkbl_rpt_block_cid_summ_day',
                        from_ds =input$dr1[1],
                        end_ds =input$dr1[2],
                        cid=cids)
    mydata$type <- ifelse(mydata$num_clk_day >=10000 & 
                            mydata$rate_ins_day<=0.00014,
           'black',
           'normal')
    mydata$rate_ins_day <- mydata$rate_ins_day * 1e4
    mydata[,c(5,1:4,6)]
  })
  

  
  
  
  output$p1 <- renderPlot({
    plot(1:10)
    })
  
  output$p2 <- renderPlot({
    plot(1:10)
    })
  
  output$p3 <- renderPlot({
    plot(1:10)
    })
  
  output$p4 <- renderPlot({
    plot(1:10)
    })
  
  output$p5 <- renderPlot({
    plot(1:10)
    })
  
  output$p6 <- renderPlot({
    plot(1:10)
    })
  
  
  output$cid_name <-  renderTable({  
    head(iris)

  },rownames=F)
  
  
  
  
  
  output$ins_did_p1 <- renderPlot({
    plot(1:10)
    })
  output$ins_ip_p1 <- renderPlot({
    plot(1:10)
    })
  
  
  output$ins_ip_p2 <- renderPlot({
    plot(1:10)
    })
  
  
  output$ins_did_p2 <- renderPlot({
    plot(1:10)
    })
  
})
