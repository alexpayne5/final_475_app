

ui <- dashboardPage( 
  dashboardHeader(title = 'USA Economy'),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Instructions", tabName = "instructions"),
      menuItem("1. Plotted Series", tabName = "plott"),
      menuItem('2. Select Plot', tabName = 'select_plot'),
      menuItem('3. Linear Regression Fitting', tabName = 'lin_fit'),
      menuItem('4. Simple Models', tabName = 'simple'),
      menuItem('5. Exponential Smoothing Models', tabName = 'ets'),
      menuItem('6. ARIMA Models', tabName = 'arima')
      
      
      
      
    )   
    
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = 'instructions',
              p('Tab 1: Plotted Time Series'),
              p('This shows the full time series for any variable of your choosing. Click the drop-down menu and select the variable of your choosing.'),
              p('Tab 2: Select Plot'),
              p('First, select the type of plot you would like to see. The options are seasonality, autocorrelation, and decomposition. Then choose the metric you would like to examine. Lastly, if you select autocorrelation, you can choose the maximum number of lags that you would like to examine.'),
              p('Tab 3: Linear Regression Fitting'),
              p('First, select a date range for the time series. Then, select the independent variable, X. Then select the dependent variable, Y. You can then see how the model compares to the actual data. If you scroll down passed the plot you can see a summary of the model.'),
              p('Tab 4: Simple Models'),
              p('First, select a date range for the time series. Then, select the metric you would like to predict. Then, select the type of model and how far out you want to predict. If you scroll passed the plot you can see a summary of the models.'),
              p('Tab 5: Exponential Smoothing Models'),
              p('First, select a date range for the time series. Then, select the metric you would like to predict. Then, select the type of model and how far out you want to predict. If you scroll passed the plot you can see a summary of the models.'),
              p('Tab 6: ARIMA Models'),
              p('First, select a date range for the time series. Then, select the metric you would like to predict. Then, how far out you want to predict. Then, select the seasonal and non-seasonal ARIMA parameters. This will only affect the Manual Arima model. If you scroll passed the plot you can see a summary of the models.')
              
              
              
              
              
              ),
      
      tabItem(tabName = "plott",
              selectInput(
                inputId = 'selected_metric2',
                label = 'Select a Metric',
                choices = names(us_change[,-1])
              ),
              
              plotOutput('ts_plot')
              
      ),
      
      tabItem(tabName = "select_plot",
              selectInput(
                inputId = 'selected_plot',
                label = 'Select a Plot',
                choices = unique(options)
              ),
              
              selectInput(
                inputId = 'selected_metric',
                label = 'Select a Metric',
                choices = names(us_change[,-1])
              ),
              
              sliderInput(
                inputId = 'selected_lags',
                label = 'Select Max Number of Lags',
                min = 1,
                max = 24,
                value = 24
              ),
              
              plotOutput('picked_plot'),
              textOutput('interpretation')
              
      ),
      tabItem(tabName = 'lin_fit',
              dateRangeInput(
                inputId = 'selected_date',
                label = 'Select a Date Range',
                min = min(us_change$Quarter),
                max = max(us_change$Quarter),
                start = min(us_change$Quarter),
                end = max(us_change$Quarter)
              ),
              selectInput(
                inputId = 'selected_x',
                label = 'Select X Variable',
                choices = names(us_change[,-1]),
                selected = 'Income'
              ),
              selectInput(
                inputId = 'selected_y',
                label = 'Select a Y Variable',
                choices = names(us_change[,-1]),
                selected = 'Consumption'
              ),
              plotOutput('tslm'),
              verbatimTextOutput('summary'),
              textOutput('interpret')
      ),
      
      
      tabItem(tabName = 'simple',
            
           box( title = "Inputs", solidHeader = TRUE, collapsible = TRUE,
               dateRangeInput(
                inputId = 'selected_date',
                label = 'Select a Date Range',
                min = min(us_change$Quarter),
                max = max(us_change$Quarter),
                start = min(us_change$Quarter),
                end = max(us_change$Quarter)
              ),
              
              selectInput(
                inputId = 'selected_met3',
                label = 'Select a Y Variable',
                choices = names(us_change[,-1])
              ),
              selectInput(
                inputId = 'selected_m2',
                label = "Select Model",
                choices = c('Naive', 'SeasonalNaive','Mean', 'Drift')
              ),
              sliderInput(
                inputId = 'selected_h',
                label = 'Select # of Years to Forecast',
                min = 1,
                max = 12,
                value = 1
              )
              ),
           fluidPage(
           fluidRow(
             box(height = 8,
              plotOutput('simple'))
              ),
           fluidRow(
             box(width = 12,
              dataTableOutput('simple_sum'))),
            
           )
        
      ),
      
      
      
      tabItem(
        tabName = 'ets',
       
      box(title =  "Inputs", solidHeader = TRUE, collapsible = TRUE,
          
        dateRangeInput(
          inputId = 'selected_date',
          label = 'Select a Date Range',
          min = min(us_change$Quarter),
          max = max(us_change$Quarter),
          start = min(us_change$Quarter),
          end = max(us_change$Quarter)
        ),
        
        selectInput(
          inputId = 'selected_met',
          label = 'Select a Y Variable',
          choices = names(us_change[,-1])
        ),
        selectInput(
          inputId = 'selected_m',
          label = "Select Model",
          choices = c('Holt', 'HoltWinters'),
          multiple = TRUE,
          selected = 'Holt'
        ),
        sliderInput(
          inputId = 'selected_h',
          label = 'Select # of Years to Forecast',
          min = 1,
          max = 12,
          value = 1
        )),
      
      fluidPage(
      
      dataTableOutput('ets_sum'),
      
      box(width = 12,
        plotOutput('ets')
      ),
      box(
        textOutput('ets_text')
      ))
      ),
      
      
      
      
 tabItem(
        tabName = 'arima',
      
      fluidRow(
        column(3, offset = 0,
        dateRangeInput(
          inputId = 'selected_date',
          label = 'Select a Date Range',
          min = min(us_change$Quarter),
          max = max(us_change$Quarter),
          start = min(us_change$Quarter),
          end = max(us_change$Quarter)
        ),
        
        selectInput(
          inputId = 'selected_met4',
          label = 'Select a Y Variable',
          choices = names(us_change[,-1])
        ),
        selectInput(
          inputId = 'selected_m3',
          label = "Select Model",
          choices = c('AutoArima', 'ManualArima'),
          multiple = TRUE,
          selected = 'AutoArima'
        ),
        sliderInput(
          inputId = 'selected_h3',
          label = 'Select # of Years to Forecast',
          min = 1,
          max = 12,
          value = 1
        )),
      column(3, offset = 0,
        sliderInput(
          inputId = 'p',
          label = 'Select Non-Seasonal p',
          min = 0,
          max = 4,
          value = 1
        ),
        sliderInput(
          inputId = 'd',
          label = 'Select Non-Seasonal d',
          min = 0,
          max = 4,
          value = 1
        )
        ,
        sliderInput(
          inputId = 'q',
          label = 'Select Non-Seasonal q',
          min = 0,
          max = 4,
          value = 1
        ))
        ,
      column(3,  offset = 0,
        sliderInput(
          inputId = 'p1',
          label = 'Select Seasonal P',
          min = 0,
          max = 4,
          value = 1
        ),
        sliderInput(
          inputId = 'd1',
          label = 'Select Seasonal D',
          min = 0,
          max = 4,
          value = 1
        ),
        sliderInput(
          inputId = 'q1',
          label = 'Select Seasonal Q',
          min = 0,
          max = 4,
          value = 1
        ))),
        
      fluidPage(
      fluidRow(  
        
        plotOutput('arima'),
        dataTableOutput('arima_sum'),
        box(
        textOutput('arima_text')
        )
      ))
      )
      
      ),
      
    )
  )






