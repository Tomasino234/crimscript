local self = {}

function self.init(tabs, window)
    print("setting up visual tab...")

    tabs["visual"] = window:AddTab("Visual")
end

return self