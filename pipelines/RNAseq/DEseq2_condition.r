directory=getwd()
sampleFiles <- grep("../*.counts",list.files(directory),value=TRUE)

sampleStrains <- c()
for (i in (strsplit(sampleFiles,"_"))){
sampleStrains <- c(sampleStrains,unlist(i)[1])
}

sampleCondition <- c()
for (i in (strsplit(sampleFiles,"_"))){
sampleCondition <- c(sampleCondition,unlist(i)[2])
}

sampleTable <- data.frame(sampleName = sampleFiles,fileName = sampleFiles,condition = sampleCondition, strain=sampleStrains)



#install.packages("ggplot2", repos='http://cran.us.r-project.org')
library("ggplot2")
#source("http://bioconductor.org/biocLite.R")
#biocLite("DESeq2")
library(DESeq2)

ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,directory = directory,design= ~condition)
colData(ddsHTSeq)$condition <- factor(colData(ddsHTSeq)$condition,levels=unique(sampleCondition))
colData(ddsHTSeq)$strain <- factor(colData(ddsHTSeq)$strain,levels=unique(sampleStrains))

dds <- DESeq(ddsHTSeq)
res <- results(dds, contrast=c("condition",unique(sampleCondition)))
#res <- res[order(res$padj),]

write.csv(as.data.frame(res),file="condition_treated_results.csv")
write.csv(as.data.frame(counts(dds, normalized=TRUE)),file="normalized_readcount.csv")

rld <- rlog(dds)

data <- plotPCA(rld, intgroup=c("condition", "strain"), returnData=TRUE)
percentVar <- round(100 * attr(data, "percentVar"))
ggplot(data, aes(PC1, PC2, color=condition, shape=strain)) + 
	geom_point(size=3) + scale_shape_manual(values=1:20)+
	xlab(paste0("PC1: ",percentVar[1],"% variance")) +
	ylab(paste0("PC2: ",percentVar[2],"% variance"))

#print(plotPCA(rld))

