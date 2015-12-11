function bracket = getBrackets(H)
% Domain knowledge
% Each rule will disable certain elements of its characteristic graph H.
% These are indicated by their roles
bracket = cell(1,length(H));
for i=1:length(H)
    nv = size(H,1);
    bracket{i} = 1:2:nv;
end