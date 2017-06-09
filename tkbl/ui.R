
library(shiny)
library(shinythemes) 

shinyUI(navbarPage( theme = shinytheme("cosmo"),
                    "TkIO BlackList",

                    tabPanel("Black List OverView",  
                             sidebarLayout( 
                               sidebarPanel( 
                                 textInput(inputId = "cidname",
                                           label = "CID Query",
                                           value="今日"),
                                 selectInput(inputId = "cid_type",
                                             label = "Channel Type ",
                                             choices =c('cooperation','custom'),
                                             selected = 'cooperation'),
                                 submitButton("Run")
                               ),
                               mainPanel( 
                                 
                                 tableOutput('cid_name')
                               )
                             ),
                             sidebarLayout( 
                               sidebarPanel( 
                                 #h5("num_clk_day"),
                                 dateRangeInput(inputId='dr1',
                                                label = 'Date Range',
                                                start='2017-05-24',
                                                end='2017-05-26'
                                                #start=Sys.Date()-1,
                                                #end=Sys.Date()-1
                                                
                                                ),
                                 numericInput(inputId = "cid_summ",
                                              label = "cid",
                                              value = 514,
                                              min=1,
                                              max=4781),
                                 submitButton("Run")
                                 ),
                               
                                 mainPanel(
                                   tabsetPanel( 
                                     tabPanel("黑设备总览", 
                                              plotOutput("did_summ_p1"),
                                              tableOutput('did_summ_t1')),
                                     tabPanel("黑IP总览", 
                                              plotOutput("ip_summ_p1"),
                                              tableOutput("ip_summ_t1")),
                                     
                                     tabPanel("黑渠道总览", 
                                              tableOutput("cid_summ_t1")
                                              
                                              )) 

                                   ))),                   
                    
                    
                    tabPanel("",  
                             sidebarLayout( 
                               sidebarPanel( 
                                 h5('Install Device BlackList'),
                                 selectInput(inputId = "ins_variable_did",
                                             label = "Device Variable",
                                             choices =c('num_ins_app_day',
                                                        'num_ins_app_week',
                                                        'num_dau_app_day'),
                                             selected = 'num_ins_app_day',
                                             multiple=FALSE),
                                 numericInput(inputId = "ins_did_cid",
                                              label = "cid",
                                              value = 514,
                                              min=1,
                                              max=4781),
                                 sliderInput(inputId = "ins_did_outter",
                                             label = "BarPlot Outter Value",
                                             value = 7,
                                             min=2,
                                             max=10),
                                 sliderInput(inputId = "ins_did_cuts",
                                             label = "BarPlot Data Cuts",
                                             value = 5,
                                             min=3,
                                             max=10),
                                 submitButton("Run")
                               ),                                   
                               mainPanel(
                                 tabsetPanel( 
                                   tabPanel("Barplot",plotOutput("ins_did_p1")),
                                   tabPanel("Boxplot",plotOutput("ins_did_p2")))
                               )               
                             ),
                             sidebarLayout( 
                               sidebarPanel( 
                                 h5('Install IP BlackList'),
                                 selectInput(inputId = "ins_variable_ip",
                                             label = "IP Variable",
                                             choices =  c('num_ins_app_day',
                                                          'num_ins_app_week',
                                                          'num_ins_did_day',
                                                          'num_dau_did_day'),
                                             selected = 'num_ins_app_day'),
                                 numericInput(inputId = "ins_ip_cid",
                                              label = "cid",
                                              value = 514,
                                              min=1,
                                              max=4781),
                                 sliderInput(inputId = "ins_ip_outter",
                                             label = "BarPlot Outter Value",
                                             value = 7,
                                             min=2,
                                             max=10),
                                 sliderInput(inputId = "ins_ip_cuts",
                                             label = "BarPlot Data Cuts",
                                             value = 5,
                                             min=3,
                                             max=10),
                                 submitButton("Run")
                               ),                                   
                               mainPanel(
                                 tabsetPanel( 
                                   tabPanel("Barplot",plotOutput("ins_ip_p1")),
                                   tabPanel("Boxplot",plotOutput("ins_ip_p2"))
                                 )
                               )               
                             )
                             
                             
                             
                    )
                    
                    
                    
                    
                    
))