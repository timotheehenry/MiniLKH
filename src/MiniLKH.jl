module MiniLKH

include("nearest_neighbor.jl")
include("2-opt.jl")


export tour_cost, nearest_neighbor, LS_2_Opt

# code ported to Julia
# mod replaced by %

# ============================
# tour cost
# ============================
function tour_cost(tour, distmat)
    N = size(distmat)[1]
    cost = sum([distmat[tour[i],tour[i+1]] for i in 1:(N-1)]) + distmat[tour[N],tour[1]]
    return cost
end

# ============================
# function to shift by 1 an index in range(1:N)
# to avoid N-1 + 1 mod N to become 0 which is a forbidden index in the range
# shift_1.(N, collect(1:N)) = 2,..,N,1
# ============================
function shift_1(N, idx)
    if idx != N-1
        return (idx+1) % N
    else
        return N
    end
end


end # end of module
