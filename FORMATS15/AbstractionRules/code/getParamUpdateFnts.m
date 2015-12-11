function f = getParamUpdateFnts(H)

for i=1:length(H)
    Hi = H{i};
    for k = 1:Hi.roles
        % Argument P is a column vector which concatenates all parameter
        % vectors from the graph H
        f{i,k} = @(P) max(P);
    end
end

       