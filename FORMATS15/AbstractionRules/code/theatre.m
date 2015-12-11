function rho = theatre(G,H,K)
% rho{x} = list of (i,k,s): x plays role k for rule i in subgraph s
nk = length(K);
for s=1:nk
    k = K{s};
end
for x=1:G.nvertices
    stages = G.vertex(x).stages;
    for s = 1:length(stages)
        Ks = K{s};
        role=find(Ks.embedding==x);
        assert(length(role)==1,'A subgraph should contain a vertex in only one role, and so that vertex should only appear once in the embedding')
        rule = Ks.isomorphicto;
        rho{x} = [rho{x}
                  rule, role, s];
    end
end
    