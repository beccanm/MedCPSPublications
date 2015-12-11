function G = getGraph(nV)
G.graph = rand(nV) > 0.5;
G.nvertices = nV;
G.nedges = length(find(G.graph));
G.nbparamsV = 4;
G.Pv = rand(nV, G.nbparamsV);
G.nbparamsE = 4;
G.Pe = rand(nE, G.nbparamsE);
for i=1:nV
    vertex(i).stages=[];
end
G.vertex = vertex;
