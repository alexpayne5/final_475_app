


server <- function(input, output) {
  
  output$ts_plot <- renderPlot({
    
    plot_df <- us_change[, c('Quarter', input$selected_metric2)]
    plot_df %>%
      autoplot()
    
  })
  
  output$picked_plot <- renderPlot({
    
    
    if(input$selected_plot == 'seasonality') {
      
      season_df <- us_change[, c('Quarter', input$selected_metric)]
      
      season_df %>%
        gg_subseries()
      
      
    } else if(input$selected_plot == 'autocorrelation') {
      
      autoc_df <- us_change[, c('Quarter', input$selected_metric)]
      
      autoc_df %>%
        ACF(lag_max = input$selected_lags) %>%
        autoplot()
      
    } else {
      
      decomp_df <- us_change[, c('Quarter', input$selected_metric)]
      
      decomp_df %>% 
        model(classical_decomposition()) %>% 
        components() %>% 
        autoplot()
      
    }
    
  })
  
  output$interpretation <- renderText({
    if(input$selected_plot == 'seasonality') {
      
      paste('There is seasonality if there are major differences in values from quarter to quarter.')
      
    } else if(input$selected_plot == 'autocorrelation') {
      
      paste('A lag is statistically significant if the bar extends further than the dotted line.')
      paste('If it is statistically significant, there is correlation amongst previous periods of the time series.')
      
    } else {
      
      paste('When this time series is decomposed, there is not a clear trend because the trend line does not steadily increase or decrease. When the time series is decomposed, there are clear patterns in the seasonal decomposition.')
      
    }
  })
  
  
  output$tslm <- renderPlot({
    my_formula <- formula(
      paste(input$selected_y, '~', input$selected_x)
    )
    
    fit <- us_change %>%
      model(TSLM(my_formula))
    
    fit %>%
      forecast(us_change) %>%
      autoplot(us_change)
    
  })
  

  
  
  output$interpret <- renderText({
    paste('If the blue line closely follows the black line, the model does a good job of fitting to historical data. In the example, Income does a better job of prediting Consumption the further along in years.')
    
  })
  
  output$simple <- renderPlot({
    
    fit <- us_change[, c("Quarter", input$selected_met3)] %>%
      model(
        Naive = NAIVE(),
        SeasonalNaive = SNAIVE(),
        Mean = MEAN(),
        Drift = RW( ~ drift())
      )
    
    fit %>%
      select(input$selected_m2) %>%
      forecast(h = input$selected_h) %>%
      autoplot(us_change)
   
  })
  
  output$simple_sum <- renderDataTable({
    
    fit <- us_change[, c("Quarter", input$selected_met3)] %>%
      model(
        naive = NAIVE(),
        snaive = SNAIVE(),
        mean = MEAN(),
        drift = RW( ~ drift())
      ) 
    
    fit %>%
      glance()
    
    
    
  })
  
 
  
  output$ets <- renderPlot({
    
    fit <- us_change[, c("Quarter", input$selected_met)] %>%
      model(
        Holt = ETS( ~ error("A") + trend("A") + season("N")),
        HoltWinters = ETS( ~ error("M") + trend("A") + season("M"))
      )
    
    fit %>%
      select(input$selected_m) %>%
      forecast(h = input$selected_h2) %>%
      autoplot(us_change)
    
  })
  
  output$ets_sum <- renderDataTable({
    
    fit <- us_change[, c("Quarter", input$selected_met)] %>%
      model(
      Holt = ETS( ~ error("A") + trend("A") + season("N")),
      HoltWinters = ETS( ~ error("M") + trend("A") + season("M"))
      ) 
    
    table <- fit %>%
      glance()
    table[ , c(1,3:7)]
      
  })
  
  output$ets_text <- renderText({
    paste('To know which model is more accurate, look to see which AIC is lower.' )
    
  })


output$arima <- renderPlot({
  
  fit <- us_change[, c("Quarter", input$selected_met4)] %>%
    model(
      AutoArima = ARIMA(),
      ManualArima = ARIMA( ~ 0 + pdq(input$p, input$d, input$q) + PDQ(input$p1,input$d1,input$q1))
    ) 
  
  
  fit %>%
    select(input$selected_m3) %>%
    forecast(h = input$selected_h3) %>%
    autoplot(us_change)
  
})

output$arima_sum <- renderDataTable({
  
  fit <- us_change[, c("Quarter", input$selected_met4)] %>%
    model(
      AutoArima = ARIMA(),
      ManualArima = ARIMA( ~ 0 + pdq(input$p, input$d, input$q) + PDQ(input$p1,input$d1,input$q1))
    ) 
  
  table <- fit %>%
    glance()
  table[ , c(1,3:7)]

  
})

output$arima_text <- renderText({
  paste('To know which model is more accurate, look to see which AIC is lower.' )
  
})

}



