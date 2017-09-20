require(grid)
require(gridExtra)
require(ggplot2)

pdf("myOut.pdf",10,6)


myfunction <- function(){

file_name="coverage.tab"
data=read.table(file_name,sep="\t",header=TRUE)
start=0

plot1=ggplot(data, aes(x = Location, y = Read.depth)) + geom_step(size = 0.6, aes(color = type)) +

  theme(axis.text = element_text(angle = 0, size = rel(1.5), hjust = +0.5,colour = "black"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(vjust = 0,  size = rel(1),colour = "black")
  )

return(plot1)
}

grid.arrange(myfunction()
             ,ncol=1, nrow=1)
dev.off()





