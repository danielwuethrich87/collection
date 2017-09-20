import operator
import csv
import sys
import math
import networkx as nx
import numpy as np
import re
import matplotlib.pyplot as plt
inputOptions = sys.argv[1:]

def main():

	sample_edges=[]
	edges=[]
	with open(inputOptions[0],'r') as f:
    		for i in f:
			line=i.replace("\n","")
			idendity=float(line.split("\t")[5])
			if idendity>= 0.999 : #and line.find("_2000")==-1:
				if line.split("\t")[1] == "ref" and line.split("\t")[3] == "ref":
					edges.append([line.split("\t")[0],line.split("\t")[2]])
				else:
					sample_edges.append([line.split("\t")[0],line.split("\t")[2]])

	graph=nx.Graph()
	graph.add_edges_from(edges)

	counter=0
	node_edges=[]
	for i in nx.connected_components(graph):
		counter+=1
		for node in  i:
			node_edges.append([node,"cluster"+str(counter)])


	graph=nx.Graph()
	graph.add_edges_from(node_edges)
	graph.add_edges_from(sample_edges)

	print "a\tb\tc"
	for i in graph.edges():
		print i[0]+"\t"+i[1]+"\t"+"pp"

	#nx.draw(graph)
	#plt.show()
	#nx.draw_random(graph)
	#plt.show()
	#nx.draw_circular(graph)
	#plt.show()
	#nx.draw_spectral(graph)
	#plt.show()

main()
