
using CSV, JSON
using DataFrames
using StatsBase: countmap

df = CSV.File(datadir("imagine_avartar.csv")) |> DataFrame
rit = CSV.File(datadir("imagine.csv")) |> DataFrame

df = filter(:userid => ∈(Set(rit.:ID)), df)

young = Set(filter(:Age => ==(rit.Age[4]), rit).:ID)

no_id = Set(filter(:Q1 => ==("No"), rit).:ID)
yes_id = Set(filter(:Q1 => !=("No"), rit).:ID)

man_id = Set(filter(:Gender => ==("M"), rit).:ID)
woman_id = Set(filter(:Gender => ==("F"), rit).:ID)
df = filter(:userid => ∈(man_id), df)
df = filter(:userid => ∈(woman_id), df)

df = filter(:userid => ∈(no_id), df)

white_id = Set(filter(:Ethicity => ==("White"), rit).:ID)

df = filter(:userid => ∈(white_id), df)
df = filter(:userid => ∉(white_id), df)

df = filter(:userid => ∉(young), df)

# s = df.:avatar[1]
# s = df.:squad[1]

# d = JSON.parse(s)[1]
# pairs(d["avatarAttributes"])
# [k for k in keys(d[1]["avatarAttributes"]) if k ∉ keys(av[1])]

# genderate simulation data for skin color
id_color = Dict(
    :userid => [], 
    :color => [])
 
for dfr in eachrow(df)

    avs = JSON.parse(dfr.squad)
    for av in avs
        for (k, v) in pairs(av["avatarAttributes"])

            if k == "skinColor" 
                push!(id_color[:color], v)
                push!(id_color[:userid], dfr.userid)
            end
                
        end
    end
end


df_skincolor = DataFrame(id_color)
CSV.write("df_skincolor.csv", df_skincolor)
@save "all_ratio.bson" all_ratios

man_ratios = []
for (k, v) in p_ratios

    if v < 0.05 || v > 0.95
        @show k => v
        push!(man_ratios, (k, v))
    end
end

@save "man_ratio.bson" man_ratios

woman_ratios = []
for (k, v) in p_ratios

    if v < 0.15 || v > 0.85
        @show k => v
        push!(woman_ratios, (k, v))
    end
end

@save "woman_ratio.bson" woman_ratios

for (k, v) in woman_ratios

    kk, c = k
    if kk == "skinColor"
        @show k => v
    end
end

skins = Dict()
for (k, v) in ratios

    kk, col = k
    if kk == "skinColor"
        skins[col] = v
    end
end
    
CSV.write("skin_color.csv", DataFrame(skins))
CSV.write("skin_color_m.csv", DataFrame(skins))
CSV.write("skin_color_w.csv", DataFrame(skins))


sim_ratios = Dict(
        "topType" => [],
        "accessoriesType" => [],
        "hairColor" => [],
        "facialHairType" => [],
        "clotheType" => [],
        "clotheColor" => [],
        "eyeType" => [],
        "eyebrowType" => [],
        "mouthType" => [],
        "skinColor" => []
    )   


d1 = run_experiment(nobs = nrow(df))["topType"] |> countmap
d2 = run_experiment(nobs = nrow(df))["topType"] |> countmap

sim_skin = Dict{String, Vector{Float32}}()

for (k, _) in d

    sim_skin[k] = []
end


for r in res

    local d
    d = r["skinColor"] |> countmap

    for (k, v) in d

        push!(sim_skin[k], d[k] / sum(values(d)))
    end

end

CSV.write("sim_skin.csv", DataFrame(sim_skin))
CSV.write("sim_skin_w.csv", DataFrame(sim_skin))
CSV.write("sim_skin_m.csv", DataFrame(sim_skin))



# people answer no
# k => v = ("topType", "ShortHairShortCurly") => 0.9629
# k => v = ("facialHairType", "BeardLight") => 0.9863
# k => v = ("hairColor", "BlondeGolden") => 0.0123
# k => v = ("topType", "WinterHat2") => 0.0473
# k => v = ("clotheType", "Overall") => 0.9935
# k => v = ("topType", "ShortHairDreads02") => 0.9968
# k => v = ("topType", "ShortHairDreads01") => 0.0111
# k => v = ("accessoriesType", "Blank") => 0.0308
# k => v = ("hairColor", "Blue") => 0.0074
# k => v = ("clotheType", "BlazerShirt") => 0.0027
# k => v = ("skinColor", "Black") => 0.0343
# k => v = ("topType", "Turban") => 0.0105

# for people not answer no


# all

# k => v = ("facialHairType", "BeardLight") => 0.9828
# k => v = ("topType", "WinterHat2") => 0.0165
# k => v = ("topType", "ShortHairDreads02") => 0.986
# k => v = ("topType", "LongHairNotTooLong") => 0.9641        
# k => v = ("topType", "ShortHairDreads01") => 0.0393
# k => v = ("accessoriesType", "Blank") => 0.0231
# k => v = ("skinColor", "Black") => 0.0249
# k => v = ("topType", "ShortHairShortRound") => 0.0418


avartars = Dict(
    "topType" => "",
    "accessoriesType" => "",
    "hairColor" => "",
    "facialHairType" => "",
    "clotheType" => "",
    "clotheColor" => "",
    "eyeType" => "",
    "eyebrowType" => "",
    "mouthType" => "",
    "skinColor" => ""
) 

av_ratio = Dict{String, Float32}(
    "topType" => 0,
    "accessoriesType" => 0,
    "hairColor" => 0,
    "facialHairType" => 0,
    "clotheType" => 0,
    "clotheColor" => 0,
    "eyeType" => 0,
    "eyebrowType" => 0,
    "mouthType" => 0,
    "skinColor" => 0
)   


for kpair in keys(ratios)

    k, t = kpair
    v = ratios[kpair]

    if av_ratio[k] > v
        av_ratio[k] = v
        avartars[k] = t
    end
end



