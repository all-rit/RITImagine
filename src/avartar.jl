include(srcdir("avartar_trait.jl"))


get_one(lst) = rand(lst, 1)[1]


function get_avartar()

    avartar = Dict(
        "topType" => get_one(TopType),
        "accessoriesType" => "Blank",
        "hairColor" => get_one(HairColors),
        "facialHairType" => get_one(FacialHairs),
        "clotheType" => get_one(Clothes),
        "clotheColor" => get_one(ClothesColor),
        "eyeType" => get_one(Eyes),
        "eyebrowType" => get_one(Eyebrow),
        "mouthType" => get_one(Mouth),
        "skinColor" => get_one(Skin)
    )   
    biasType = get_one(bias)

    if biasType == "hats"

        avartar["topType"] = get_one(hats)
    elseif biasType == "glasses"

        avartar["accessoriesType"] = get_one(glasses)
    elseif biasType == "shirtColor"

        avartar["clotheType"] = get_one(noBlazerClothes)
        avartar["clotheColor"] = get_one(shirtColor)
    elseif biasType == "hairColor"

        avartar["topType"] = get_one(noBaldTopType)
        avartar["hairColor"] = get_one(hairColor)
    end

    avartar
end


function emulate_once()
   
    avartar_list = [get_avartar() for _ in 1:1000]
    showed_lst = rand(avartar_list, 16)
    rand(showed_lst, 3)
end

function run_experiment(;nobs = 170)

    avartars = Dict(
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

    for _ in 1:nobs

        for av in emulate_once()

            for (k, v) in pairs(av)

                push!(avartars[k], v)
            end
        end
    end

    avartars
end