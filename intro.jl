using DrWatson
@quickactivate "RITImagine"

println(
"""
Currently active project is: $(projectname())

Path of active project: $(projectdir())

Have fun with your new project!

You can help us improve DrWatson by opening
issues on GitHub, submitting feature requests,
or even opening your own Pull Requests!
"""
)


path = raw"F:\steam\steamapps\common\Monster Hunter World\nativePC\pl\f_equip\pl115_0000"


for (root, dirs, files) in walkdir(path)

    new_path  = replace(root, "115"=> "121")
    for dir in dirs
        mkdir(joinpath(new_path, dir))
    end
    for f in files
        # @show f
        old_name = joinpath(root, f)
        new_name = replace(old_name, "115"=>"121")
        mv(old_name, new_name)
    end
end