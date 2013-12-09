library(shiny)
library(ShinyDash)
library(XML)
library(httr)
library(igraph)
library(stringr)
library(seqinr)
library(googleVis)
library(rCharts)

load("AdjMat.rDa")
#load("ind_deg.rDa")
load("listmat.rDa")
load("yearly_summary.rDa")
#load("dataS.rDa")

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
		
		
		dat=listmat[[input$Year-1969]][,1:2]
		dat=cbind(dat, as.numeric(as.factor(dat[,2])))
	#	dat[,2]= paste(dat[,2], "(", sep=" ")
	#	dat[,2]= paste(dat[,2], dat[,3], ")", sep="")
		colnames(dat)=c("Songs", "Writer ", "Link")
		
		dat[,3]=paste("http://wikipedia.com",dat[,1], sep="")
		dat[,1]= str_replace_all(dat[,1], "[[:punct:]]", " ")
		dat[,1]= str_replace_all(dat[,1], "[[:digit:]]", " ")
		dat[,1]= str_replace_all(dat[,1], "wiki", " ")
		dat[,1]=trimSpace(dat[,1])
		dat[,1]= str_replace_all(dat[,1], "    ", " ")
		dat[,1]= str_replace_all(dat[,1], "   ", " ")
		dat[,1]= str_replace_all(dat[,1], "  ", " ")
		dat[,2]=gsub( "([A-Z])", " \\1", dat[,2], perl=T)
		dat=data.frame(dat)
		colnames(dat)=c("Songs", "Writer", "Link")
		dat=transform(dat, Songs = paste('<a href = ', shQuote(Link), 'target="_blank">', Songs, '</a>')) 	
		dat=dat[,1:2]	
		colnames(dat)=c("Songs", "Writer")
		
		unique_song=unique(dat$Songs)
		unique_dat=matrix(0, nrow=length(unique_song), ncol=2)
		unique_dat[,1]=unique_song
		k=1
		for (v in unique_song){
			tempDat=dat[dat[,1]==v, 2]
			unique_dat[k,2]=paste(as.character(tempDat), collapse=", ")
			k=k+1
		}		
		
		unique_dat=data.frame(unique_dat)
		colnames(unique_dat)=c("Songs", "Writers")
		

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
		plot(x=1970:2013, yearly_summary[,input$type], type="b", cex=.5, xlab="Year", ylab=input$type, 	ylim=c(0,round(max(yearly_summary[,input$type]), digits=0)), main=main())
		points(x=input$Year, y=yearly_summary[input$Year-1969,input$type], col="red", bg="red", pch=21, cex=2)

		})	
		 
    output$mainnet <- reactiveAdjacencyMatrix(function() {
    
    data=AdjMat[[input$Year-1969]]
    

	data
  })


})
