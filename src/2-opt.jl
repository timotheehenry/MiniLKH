# ============================
# http://tsp-basics.blogspot.com/2017/02/building-blocks-reversing-segment.html
# ============================
function Reverse_Segment(tour::Vector{Int};
    startIndex::Int, endIndex::Int)
    ## Reverses order of elements in segment [startIndex, endIndex]
    ## of tour.
    ## NOTE: Final and initial part of tour make one segment.
    ## NOTE: While the order of arguments can be safely changed when
    ## reversing segment in 2-optimization, it makes difference for
    ## 3-opt move - be careful and do not reverse (x,z) instead of (z,x).

    N = length(tour)
    inversionSize =  ((N + endIndex - startIndex + 1) % N ) ÷ 2

    left  = startIndex
    right = endIndex

    for counter in 1:inversionSize
        # swap(tour[left], tour[right])
        tour[left], tour[right] = tour[right], tour[left]

        #left  = (left + 1) % N
        left = shift_1(N, left)
        
        #right = (N + right - 1) % N
        right = shift_n(N, N-1, right)

    end

    return tour
end

# ============================
# 2-opt
# http://tsp-basics.blogspot.com/2017/03/2-opt-move.html
# ============================
function Gain_From_2_Opt(distmat, X1, X2, Y1, Y2)
    ## Gain of tour length that can be obtained by performing
    ## given 2-opt move
    # Assumes: X2==successor(X1); Y2==successor(Y1)
    del_Length = distmat[X1, X2] + distmat[Y1, Y2]
    add_Length = distmat[X1, Y1] + distmat[X2, Y2]
    Length_Gain = del_Length - add_Length

    return Length_Gain

end


function Make_2_Opt_Move(tour; i, j)
    ## Performs given 2-opt move on array representation of the tour
    # We cut the cyclic tour in 2 places, by removing 2 links:
    #   L1: from t[i] to t[i+1]  and  L2: from t[j] to t[j+1]
    # and replacing them with
    #   L1': from t[i] to t[j]   and  L2': from t[i+1] to t[j+1]
    # This is equivalent to reversing order in segment from 'i+1' to 'j'
    N = length(tour)
    Reverse_Segment(tour, startIndex=shift_1(N,i), endIndex=j)
end


# ============================
# 2-opt
# http://tsp-basics.blogspot.com/2017/03/2-opt-basic-iterative-algorithm.html
# ============================
function LS_2_Opt(tour, distmat)
    ## Iteratively optimizes given tour using 2-opt moves.
    # Shortens the tour by repeating 2-opt moves until no improvement
    # can by done; in every iteration immediatelly makes permanent
    # change from the first move found that gives any length gain.

    N = size(distmat)[1]
    locallyOptimal = false

    while !(locallyOptimal)
        locallyOptimal = true
        
        for counter_1 in 1:(N-2)
            #print("counter_1 = $counter_1 \n")
            i = counter_1
            X1 = tour[i]
            X2 = tour[shift_1(N, i)]

            if i == 1
                counter_2_Limit = N-1
            else
                counter_2_Limit = N 
            end

            for counter_2 in (i+2):counter_2_Limit
                #print("counter_2 = $counter_2 \n")
                j = counter_2
                Y1 = tour[j]
                Y2 = tour[shift_1(N, j)]

                gainExpected = Gain_From_2_Opt(distmat, X1, X2, Y1, Y2)

                if gainExpected > bestMove.gain
                    # this move will shorten the tour, apply it at once
                    Make_2_Opt_Move(tour, i=i, j=j)
                    print("Tour shortened by $gainExpected \n")
                    locallyOptimal = false
                    break
                end
            end
        end
    end

end # end of LS_2_Opt




# ============================
# 2-opt
# http://tsp-basics.blogspot.com/2017/03/2-opt-basic-iterative-algorithm.html
# ============================
mutable struct Move2
    i::Int;
    j::Int;
    gain::Int;
end

function LS_2_Opt_Take_Best(tour, distmat)
    # Shortens the tour by repeating 2-opt moves until no improvement
    # can by done; in every iteration looks for and applies the move
    # that gives maximal length gain.

    N = size(distmat)[1]
    locallyOptimal = false
    bestMove = Move2(0,0,0)

    while !(locallyOptimal)
        locallyOptimal = true
        bestMove.gain = 0

        for counter_1 in 1:(N-2)
            i = counter_1
            #print("i = $i \n")

            X1 = tour[i]
            X2 = tour[shift_1(N,i)]

            if i == 1
                counter_2_Limit = N-1
            else
                counter_2_Limit = N
            end

            for counter_2 in (i+2):counter_2_Limit
                j = counter_2
                #print("j = $j \n")

                Y1 = tour[j]
                Y2 = tour[shift_1(N,j)]

                gainExpected = Gain_From_2_Opt(distmat, X1, X2, Y1, Y2)

                if gainExpected > bestMove.gain
                    #print("improvement found \n")
                    #print(bestMove, "\n")
                    bestMove = Move2(i,
                                    j,
                                    gainExpected)
                    #print(bestMove, "\n")

                    locallyOptimal = false
                end
            end
        end # end_for counter_1 loop

        if !(locallyOptimal)
            Make_2_Opt_Move(tour, i = bestMove.i, j = bestMove.j)
            gain = bestMove.gain
            print("Tour shortened by $gain \n")
        end 
    end # end_while not locallyOptimal 
end 
