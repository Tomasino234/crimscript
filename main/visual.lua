local self = {}

function self.init(tabs, library)
    print("setting up visual tab...")

    tabs["visual"] = library:AddTab("Visual")
end

return self