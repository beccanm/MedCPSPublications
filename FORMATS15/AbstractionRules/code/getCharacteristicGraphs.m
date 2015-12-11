function H = getCharacteristicGraphs(nRules)
% characteristic graphs and their list of disabled vertices.
% Edges and vertices that are disabled by application of rule i on their
% graph. <i> of the paper
% Domain knowledge
% Each rule will disable certain elements of its characteristic graph H.
% These are indicated by their roles

for i=1:nRules
    nvertices = 4;
    h.graph = rand(nvertices) > 0.5;
    ne = find(h.graph);
    h.roles = 1:(nvertices+length(ne));
    h.bracket = 1:2:nvertices;
    H{i} = h;
end



