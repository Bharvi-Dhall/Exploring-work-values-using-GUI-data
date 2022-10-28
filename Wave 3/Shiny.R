# Shiny to run the main effects logistic regression on work values
#Run 02_TD_Modelling.Rmd before running this file

library(here)
here::i_am("CATAv2/Shiny.R")
knitr::purl(here("CATAv2","02_TD_Modelling.Rmd" ))


library(shiny)

shiny_test <- function(data){
  
  data <- as.data.frame(data)
  y <- data[,1:10] # omit other
  #get rid of IDs
  x <- data[,-c(1:11,which(names(data)=="ID"), 
                which(names(data)== "schoolID"))]
  x1 <- x %>%
    dplyr::select(-c("TY",  "PC1_emp" , "PC1_edu", "left_school"))
  
  ui <- fluidPage(
    fluidRow(
      column(9, 
             plotOutput("heatmap")),
      column(3,
             plotOutput("lollipop"))
    ),
    fluidRow(
      column(2,
             selectInput("res","pick a response",
                         choices = colnames(y))
      ),
      column(4,
             plotOutput("coef_plot_mains")
      ),
      column(6,
             plotOutput("interactions"))
    )
  )
  server <- function(input,output,session){
    fits.1 <- map(y, ~ glm(.x ~ . + own_family_imp*gender + conscientious_score*gender +
                             school_type*gender ,family="binomial",data=x1))
    f <- purrr::map_dfr(fits.1, ~ broom::tidy(car::Anova(.x)), .id="response")
    f1 <- dplyr::filter(f, term != "Residuals")
    
    # make heatmap
    cols <- c("blue", "cyan", "grey95")
    heatmap <- modelHeatmap(f1, "term", "response", "p.value", xorder="increasing", yorder="increasing")+
      ggplot2::scale_fill_manual(values = cols)+ 
      ggplot2::xlab("Variables driving Work-Values") + 
      ggplot2::ylab("Work-Values") + 
      ggplot2::ggtitle("Heatmap of 10 Logistic Regression fits of the Work-Values")
    
    output$heatmap <- renderPlot(heatmap)
    #aic
    ordered_response <- c("help_society", 
                          "flex_hours", 
                          "job_security",
                          "time_off",
                          "high_inc",
                          "travel_abroad",
                          "being_boss",
                          "training_opp",
                          "interesting_job",
                          "good_for_career"
    )
    for(i in 1:length(ordered_response)){
      val[i] <- fits.1[[ordered_response[i]]][["aic"]]
    }
    score <- data.frame(work_val = ordered_response, AIC = val)
    
    score$work_val <- fct_inorder(score$work_val) %>% fct_rev()
    
    aic_plot <- score %>%
      ggplot(aes(x=AIC,y=work_val)) +
      geom_point(size = 3, colour = "black") + 
      geom_segment(aes(x=0,xend = AIC,y=work_val,yend=work_val ), size = 1.2)
    
    output$lollipop <- renderPlot(aic_plot)
    
    # coefficients plot
    include_vars <- base::setdiff(names(x1),c("own_family_imp","gender","conscientious_score",
                                              "cognitive_scores","school_type"))
    
    main_effects_coef <- eventReactive(input$res,{
      ggcoef_model(fits.1[[input$res]],include = include_vars,
                   shape_values= c(19,1), point_stroke=.5,
                   errorbar_coloured=F, point_size=3 )
      
    })
    
    output$coef_plot_mains <- renderPlot(main_effects_coef(),height = 400)
    
    #Interaction Plot
    inter_effects <- eventReactive(input$res,{
      
      p1 <- plot(ggpredict(fits.1[[input$res]], rev(c("gender", "own_family_imp")))) +
        geom_line(aes(linetype=group), 
                  position=position_dodge(width=.25))+
        theme(legend.position = "bottom")
      p2 <- plot(ggpredict(fits.1[[input$res]], rev(c("gender", "conscientious_score")))) +
        geom_line(aes(linetype=group), 
                  position=position_dodge(width=.25))+
        theme(legend.position = "bottom")
      p3 <- plot(ggpredict(fits.1[[input$res]], rev(c("gender", "cognitive_scores")))) +
        geom_line(aes(linetype=group), 
                  position=position_dodge(width=.25))+
        theme(legend.position = "bottom")
      p4 <- plot(ggpredict(fits.1[[input$res]], rev(c("gender", "school_type")))) +
        geom_line(aes(linetype=group), 
                  position=position_dodge(width=.25))+
        theme(legend.position = "bottom")
      cowplot::plot_grid(p1, p2, p3, p4, nrow = 2, ncol = 2)
      
      
    })
    
    output$interactions <- renderPlot(inter_effects(),height = 400)
    
    
  }
  
  shinyApp(ui=ui,server=server)
}
# Running Shiny app
shiny_test(data=data)

