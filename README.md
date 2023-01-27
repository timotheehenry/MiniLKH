# MiniLKH

MiniLKH is a barebone implementation of the LKH library for solving TSP (Traveling Salesman Problem).

It does not implement all features of the LKH library.
My goal is to have a pure Julia implementation, and be close to the LKH results with the least lines of codes.

## Installation

```jl
pkg> add https://github.com/timotheehenry/MiniLKH.git
```

## Usage

```jl
using MiniLKH
using TSPLIB

tsp = readTSPLIB(:a280)

# ====================
# distance matrix = tsp.weights
# ====================
distmat = Int.(tsp.weights);

# ====================
# 1. nearest neighbor
# ====================
tour, cost = nearest_neighbor(distmat)
# ([1, 280, 2, 3, 279, 278, 4, 277, 276, 275  …  57, 58, 68, 69, 77, 78, 186, 204, 205, 206], 3157)

tour_cost(tour, distmat)
# 3157
# 22% above optimal

# ====================
# 2. 2-opt
# ====================
LS_2_Opt(tour, distmat)

tour_cost(tour, distmat)
# 2767
# 7% above LKH optimal

# ====================
# Let's compare with the original LKH
# ====================
using LKH
LKH.solve_tsp(distmat)
# ([1, 2, 242, 243, 241, 240, 239, 238, 237, 236  …  259, 258, 257, 256, 249, 248, 278, 279, 3, 280], 2579)

LKH.solve_tsp(distmat, MOVE_TYPE=2, log="on")
# ([1, 2, 242, 243, 244, 241, 240, 239, 238, 237  …  259, 258, 257, 256, 249, 248, 278, 279, 3, 280], 2579)
# The tour is 7% shorter; obviously LKH is doing more than just 2-opt even if we specify MOVE_TYPE = 2

```



## Current status

[x] 2-opt

[ ] 3-opt

[ ] Anything else


