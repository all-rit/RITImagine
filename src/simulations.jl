using ProgressMeter
using BSON: @save, @load
include(srcdir("avartar.jl"))
using Statistics


# # ANCHOR - Run 1000 experiments
# @save datadir("simulations_1000.bson") res


# ounts = []
# for r in res
    
#     push!(counts, sum(r["skinColor"] .== "Light") / length(r["skinColor"]))
# end


# mean(counts)


# d = (res[3]["skinColor"] |> countmap)

# dv = Dict{String, Float32}()

# for (k, v) in d

#     dv[k] = d[k] / 3nrow(df)
# end




function find_bias(data; nsims = 10_000)
    
    @info "run simulation"
    res = []
    @showprogress for _ in 1:nsims

        push!(res, run_experiment(;nobs = nrow(df)))
    end


    
    counter = Dict()

    for s in df.:squad

        avs = JSON.parse(s)
        for av in avs
            for (k, v) in pairs(av["avatarAttributes"])
                
                if haskey(counter, (k,v))
                    counter[(k, v)] += 1
                else    
                    counter[(k, v)] = 1
                end
            end
        end
    end

    ratios = Dict()

    for (k, v) in counter

        ratios[k] = counter[k] / nrow(df) / 3
    end



    p_ratios = Dict()

    @showprogress for (k, v) in ratios

        local counts = []
        for r in res
            
            push!(counts, sum(r[k[1]] .== k[2]) / length(r[k[1]]))
        end

        p_ratios[k] = sum(counts .< v) / length(res)

    end

    
    all_ratios = []
    for (k, v) in p_ratios

        if v < 0.05 || v > 0.95
            @show k => v
            push!(all_ratios, (k, v))
        end

    end

    all_ratios
end






cend
