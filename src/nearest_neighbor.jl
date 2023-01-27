# ============================
# nearest neighbor
# ============================
function nearest_neighbor(distmat::AbstractMatrix{Int})
    # start at 1 and visit nearest until all are visited
    @assert size(distmat)[1] == size(distmat)[2]  "Not a square matrix"

    N = size(distmat)[1]

    path = [1]
    cities_to_visit = collect(2:N)
    cost = 0

    for i in 2:N
        dist_to_next_city, idx_next_city = findmin(distmat[path[end],cities_to_visit])
        next_city = cities_to_visit[idx_next_city]
        cost += dist_to_next_city
        push!(path, next_city)
        filter!(e->e≠next_city, cities_to_visit)
    end

    # return to first node
    cost += distmat[path[end], 1]

    return (path, cost)
end

