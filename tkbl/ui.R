
library(shiny)
library(shinythemes) 

shinyUI(navbarPage( theme = shinytheme("yeti"),
                    "TKIO BlackList",

                    tabPanel("Black List OverView",  
                             sidebarLayout( 
                               sidebarPanel( 
                                 helpText('CID Query: enter cid number or cid_name'),
                                 textInput(inputId = "cidname",
                                           label = "",
                                           value="514"),
                                 selectInput(inputId = "cid_type",
                                             label = "Channel Type ",
                                             choices =c('cooperation','custom'),
                                             selected = 'cooperation'),
                                 h4(),
                                 downloadButton(outputId='cidData', 
                                                label = 'download cid info'),
                                 h4(),
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
                                                #start='2017-05-24',
                                                #end='2017-05-26'
                                                start=Sys.Date()-11,
                                                end=Sys.Date()-2
                                                
                                                ),
                                 numericInput(inputId = "cid_summ",
                                              label = "cid",
                                              value = 514,
                                              min=1,
                                              max=10000),
                                 submitButton("Run"),
                                 h4(),
                                 downloadButton(outputId='downloadData', 
                                                label = 'download cid data set'),
                                 h4()
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
                    tabPanel("Rules OverView",  
                             sidebarLayout( 
                               sidebarPanel( 
                                 h5('Device BlackList'),
                                 dateRangeInput(inputId='r_did_dr',
                                                label = 'Date Range',
                                                #start='2017-05-24',
                                                #end='2017-05-26'
                                                start=Sys.Date()-11,
                                                end=Sys.Date()-2
                                                
                                 ),
                                 helpText('-1 means all cid'),
                                 numericInput(inputId = "r_did_cid",
                                              label = "cid",
                                              value = -1,
                                              min=-1,
                                              max=10000),
                              
                                 submitButton("Run")
                               ),                                   
                               mainPanel(
                                 tabsetPanel( 
                                   tabPanel("ALL",
                                            plotOutput("r_did_p1"),
                                            tableOutput('r_did_t1')),
                                   tabPanel("DAY",
                                            plotOutput("r_did_p2"),
                                            tableOutput('r_did_t2') ))
                               )               
                             ),
                             sidebarLayout( 
                               sidebarPanel( 
                                 h5('IP BlackList'),
                                 dateRangeInput(inputId='r_ip_dr',
                                                label = 'Date Range',
                                                #start='2017-05-24',
                                                #end='2017-05-26'
                                                start=Sys.Date()-11,
                                                end=Sys.Date()-2
                                                
                                 ),
                                 helpText('-1 means all cid'),
                                 numericInput(inputId = "r_ip_cid",
                                              label = "cid",
                                              value = -1,
                                              min=-1,
                                              max=10000),
                              
                                 submitButton("Run")
                               ),                                   
                               mainPanel(
                                 tabsetPanel( 
                                   tabPanel("ALL",plotOutput("r_ip_p1"),
                                            tableOutput('r_ip_t1') ),
                                   tabPanel("DAY",plotOutput("r_ip_p2"),
                                            tableOutput('r_ip_t2'))
                                 )
                               )               
                             )
                             
                             
                             
                    ),
                    
                    tabPanel("Day OverView",
                             sidebarLayout( 
                               sidebarPanel( 
                                 textInput(inputId = "d_query_appid",
                                           label = "chooose appid or appid name",
                                           value='064f86cbdc474d65df4e9fd47f58213b'),
                                 submitButton("Run")
                               ),                                   
                               mainPanel(
                                 tableOutput('app_info')
                               )               
                             ),
                             sidebarLayout( 
                               sidebarPanel( 
                                 h5('Click'),
                                 helpText('all means all appid'),
                                 textInput(inputId = "d_clk_appid",
                                             label = "Enter appid",
                                             value='all'),
                                 dateRangeInput(inputId='d_clk_dr',
                                                label = 'Date Range',
                                                #start='2017-05-24',
                                                #end='2017-05-26'
                                                start=Sys.Date()-5,
                                                end=Sys.Date()-2
                                                
                                 ),
                                 submitButton("Run")
                               ),                                   
                               mainPanel(
                                 tabsetPanel( 
                                   tabPanel("Data",
                                            plotOutput("p3"),
                                            tableOutput('t3')) )
                               )               
                             ),
                             sidebarLayout( 
                               sidebarPanel( 
                                 h5('Install'),
                                 helpText('all means all appid'),
                                 textInput(inputId = "d_ins_appid",
                                             label = "Enter appid",
                                             value='all'),
                                 dateRangeInput(inputId='d_ins_dr',
                                                label = 'Date Range',
                                                #start='2017-05-24',
                                                #end='2017-05-26'
                                                start=Sys.Date()-5,
                                                end=Sys.Date()-2
                                                
                                 ),
                                 submitButton("Run")
                               ),                                   
                               mainPanel(
                                 tabsetPanel( 
                                   tabPanel("Data",plotOutput("p4"),
                                            tableOutput('t4') )
                                 )
                               )               
                             )
   
                    ) , # end
                    
                    
                    tabPanel("CID OverView",
                             sidebarLayout( 
                               sidebarPanel( 
                                 dateInput(inputId = "cid_ds",
                                           label = "Enter Date",
                                           value='2017-06-11' ),
                                 h4(),
                                 downloadButton(outputId='cid_clk', 
                                                label = 'download cid clk'),
                                 h4(),
                                 downloadButton(outputId='cid_ins', 
                                                label = 'download cid ins'),
                                 h4(),
                                 submitButton("Run")
                               ),                                   
                               mainPanel(
                                 plotOutput('xp1'),
                                 plotOutput('xp2')
                               )               
                             )
                             
                    )              
                    
                    
                    
                    
                    
))