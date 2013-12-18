library(shiny)
library(ShinyDash)
library(XML)
library(httr)
library(igraph)
library(stringr)
library(seqinr)
library(googleVis)
library(rCharts)

#load("AdjMat.rDa")
#load("ind_deg.rDa")
load("listmat.rDa")
load("yearly_summary.rDa")
load("AdjMatF.rDa")
load("unSongMatList.rDa")

AdjMat=AdjMatF

reactiveAdjacencyMatrix <- function(func){
  reactive(function(){
    
	val=func()
    
    #diag(val) <- 0
    
    #make the matrix symmetric
    #val <- symmetricize(val, method="avg")
    
    #now consider only the upper half of the matrix
    #val[lower.tri(val)] <- 0
  
    #mat=AdjMat[[input$Year-1969]]
   # mat[lower.tri(mat,diag=TRUE)] = 0
    #val = mat

    conns <- cbind(source=row(val)[val>0]-1, target=col(val)[val>0]-1, weight=val[val>0])
    rownames(val)=gsub( "([A-Z])", " \\1", rownames(val), perl=T)  
    list(names=rownames(val), links=conns)
  })

}


shinyServer(function(input, output) {
	
  
	plotVal= reactive({  
		
		dat=unSongMatList[[input$Year-1969]][,c(1,2,6)]	
	
		
		unique_dat=data.frame(unique_dat)
		colnames(unique_dat)=c("Songs", "Writers", "Spotify")

		return (unique_dat)

		})
	
	main=reactive({
		if (input$type=="Degree Average")
			{main="Time-Series of Average Degree"}
		else if (input$type=="Clustering Coefficient")
			{main="Time-Series of Clustering Coefficient"}
		else if (input$type=="Network Density (%)")
			{main= "Time-Series of Network Density"}
		else 
			{main="Time-Series of LSCC"}
		return (main)
	})
		
		
	output$List= renderGvis({
		   gvisTable(plotVal(), options = list(allowHTML = TRUE, height= "260px", 	width="587",
		   													showRowNumber=TRUE))

		})
	
	
	
		
	output$scatter= 
	renderPlot({
		plot(x=1970:2013, yearly_summary[,input$type], type="l", cex=.5, xlab="Year", ylab=input$type, 	ylim=c(0,round(max(yearly_summary[,input$type]), digits=0)), main=main())
		points(x=input$Year, y=yearly_summary[input$Year-1969,input$type], col="red", bg="red", pch=21, cex=2)

		})	
		 
    output$mainnet <- reactiveAdjacencyMatrix(function() {
    
    data=AdjMat[[input$Year-1969]]
    

	data
  })


})
