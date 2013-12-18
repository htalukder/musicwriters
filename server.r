download_not_installed<-function(x){
	for(i in x){
		if(!require(i,character.only=TRUE)){
	  		install.packages(i,repos="http://cran.r-project.org")
  			library(i,character.only=TRUE)
  		}
	}
}
required_packages = c("shiny","XML","httr","igraph","stringr","seqinr","googleVis","devtools")
download_not_installed(required_packages)

if(!(require("rCharts"))){
	devtools::install_github('rCharts', 'ramnathv')
}
if(!(require("ShinyDash"))){
	devtools::install_github("ShinyDash", "trestletech")
}

#load("AdjMat.rDa")
#load("ind_deg.rDa")
load("./Data/listmat.rDa")
load("./Data/yearly_summary.rDa")
load("./Data/AdjMatF.rDa")
load("./Data/unSongMatList.rDa")

AdjMat=AdjMatF

reactiveAdjacencyMatrix <- function(func){
  reactive(function(){
	val=func()
    conns <- cbind(source=row(val)[val>0]-1, target=col(val)[val>0]-1, weight=val[val>0])
    rownames(val)=gsub( "([A-Z])", " \\1", rownames(val), perl=T)  
    list(names=rownames(val), links=conns)
  })

}

shinyServer(function(input, output) {
	plotVal= reactive({  
		dat=unSongMatList[[input$Year-1969]][,c(1,2,5)]	
		temp=dat[,3]
		songL=rep(0, length(temp))
		for ( i in 1:length(temp)){
			songU=as.character(temp[i])
			songL[i]=paste('<iframe src="https://embed.spotify.com/?uri=',songU,'" width="250" height="80" frameborder="0" allowtransparency="true"></iframe>', sep="")
		}
		unique_dat=cbind(dat[,1:2], songL)
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