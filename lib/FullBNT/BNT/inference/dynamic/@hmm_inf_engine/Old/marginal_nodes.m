function marginal = marginal_nodes(engine, nodes, t, add_ev)
% MARGINAL_NODES Compute the marginal on the specified query nodes (hmm)
% marginal = marginal_nodes(engine, nodes, t, add_ev)
%
% 't' specifies the time slice of the earliest node in 'nodes'.
% 'nodes' cannot span more than 2 time slices.
%
% Example:
% Consider a DBN with 2 nodes per slice.
% Then t=2, nodes=[1 3] refers to node 1 in slice 2 and node 1 in slice 3,
% i.e., nodes 3 and 5 in the unrolled network,

if nargin < 3, t = 1; end
if nargin < 4, add_ev = 0; end

bnet = bnet_from_engine(engine);
ss = length(bnet.intra);
if all(nodes <= ss)
  bigpot = engine.one_slice_marginal{t};
else
  bigpot = engine.two_slice_marginal{t};
end

nodes = nodes + (t-1)*ss;
marginal = pot_to_marginal(marginalize_pot(bigpot, nodes, engine.maximize));

if add_ev
  marginal = add_ev_to_dmarginal(marginal, engine.evidence, engine.node_sizes);
end    

