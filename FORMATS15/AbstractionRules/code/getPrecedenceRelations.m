function prec = getPrecedenceRelations(H)
nRules = length(H);
prec = cell(1,nRules);
for i=nRules-1:nRules
    prec{i} = i-1;
end