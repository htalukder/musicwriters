library(shiny)
library(ShinyDash)
require(devtools)
library(rCharts)

reactiveNetwork <- function (outputId) 
{
  HTML(paste("<div id=\"", outputId, "\" class=\"shiny-network-output\"><svg /></div>", sep=""))
}


shinyUI(bootstrapPage(
  h1("Writers of Number 1 Singles "),
  
  gridster(tile.width = 280, tile.height = 5,
    
	gridsterItem(col = 1, row = 1, size.x = 2, size.y = 3,
                
                sliderInput("Year", "Choose Year",
                            min = 1970, max = 2013, value = 1970, format="####")


    ),
				

	gridsterItem(col = 3, row = 1, size.x = 2, size.y = 9,
				  tags$head(
        		tags$style(type="text/css", "select { height: 30px; width: 300px; fontSize:2}")),

				selectInput("type", "Choose Descriptive Statistics:",
                 list("Average Degree" = "Degree Average",
                      "Clustering Coefficient" = "Clustering Coefficient",
                      "Largest Strongly Connected Component"= "LSCC",
                      "Network Density"= "Network Density (%)")),


                 plotOutput("scatter", height="230px")
			

)
				
    ,

	gridsterItem(col = 1, row = 4, size.x = 2, size.y = 12,
                  includeHTML("graph.js"),
    			reactiveNetwork(outputId = "mainnet") 
    		
                
    ),
    gridsterItem(col = 3, row = 10, size.x = 2, size.y = 8,
                  htmlOutput("List") 
    
    ),

	gridsterItem(col = 1, row = 16, size.x = 2, size.y = 2,
                  tags$p("",
                  #tags$br(),
                  tags$a(href = "https://github.com/htalukder/musicwriters", 				"Source Code", target="_blank")
                ),
		   tags$p("Copyright:",
                  #tags$br(),
                  tags$a(href = "http://cbcb.umd.edu/~htalukde", 				"Hisham Talukder", target="_blank")
                )

    )



  )
))
