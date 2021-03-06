function bnet = hodbn_to_bnet(dbn, T)
% DBN_TO_BNET Convert a DBN to a static network by unroll for T slices
% bnet = dbn_to_bnet(dbn, T)
ss = length(dbn.intra);
[row,order] = size(dbn.equiv_class);
eclass = [];
for i = 1:min(order,T)
     eclass = [eclass ; dbn.equiv_class(:,i)];
end
if T > order
    eclass = [eclass ; repmat(dbn.equiv_class(:,order),T-order,1)]; 
end

dnodes = unroll_set(dbn.dnodes_slice, ss, T);
ns = repmat(dbn.node_sizes_slice(:), 1, T);
dag = unroll_higher_order_topology(dbn.intra, dbn.inter, T, dbn.intra1);
onodes = unroll_set(dbn.observed(:), ss, T);
bnet = mk_bnet(dag, ns(:), 'discrete', dnodes(:), 'equiv_class', eclass(:), 'observed', onodes(:));
bnet.CPD = dbn.CPD;
 

