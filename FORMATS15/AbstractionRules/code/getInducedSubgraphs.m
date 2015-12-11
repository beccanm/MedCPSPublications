function K = getInducedSubgraphs(H,G)
K = cell(1,length(H));
for i=1:length(H)
    h = H{i};
    nv = size(h,1);
    % embedding maps K's vetices to their location in G:
    % embeddeing is 1-by-nv, embedding(i) gives the G vertex equal to
    % vertex i.
    k.embedding = 1:nv;
    % Also, provide reverse link from G to Ks
    for j=1:nv
        G.vertex(k.embedding(j)).stages = [G.vertex(k.embedding(j)).stages, i];
    end
    % Moreover, K's vertices are in the same order as H's, so the
    % isomorphism is the identity, i.e. the 1st vertex of K is the 1st
    % vertex of H, and so on. So we don't dedicate a data structure for
    % that.
    % The H graph to which K is isomorphic. Also gives the index of the
    % rule since rules and their graphs are coupled uniquely
    k.isomorphicto = i;  
    % For completeness and to reduce cross-referencing, embed a copy of H
    % in this structure
    k.graph = h.graph;
    
    K{i} = k;
end

