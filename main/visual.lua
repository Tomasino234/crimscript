local self = {}

-- visual tab

-- callbacks

function colorMode()
end

------------
-- visual variables --

local esp_enabled = false
local esp_toggles = {
    Chams = false,
    Health = false,
    Tool = false,
}

----------------------

function setup1(section)
   section:AddToggle({
	    enabled = true,
	    text = "ESP Enabled",
	    flag = "Esp_Enabled",
	    tooltip = "Sets if ESP is even rendered.",
	    risky = false,
	    callback = function(lol : boolean)
	        esp_enabled = lol
	    end
    })

    section:AddSeparator({
	    text = "ESP Toggles"
    })

    section:AddToggle({
	    enabled = true,
	    text = "Chams",
	    flag = "Chams_Enabled",
	    tooltip = "Sets if enemy character highlight is enabled.",
	    risky = false,
	    callback = function(lol : boolean)
	        esp_toggles.Chams = lol
	    end
    })

    section:AddToggle({
	    enabled = true,
	    text = "Health",
	    flag = "Health_Enabled",
	    tooltip = "Sets if enemy character health is shown.",
	    risky = false,
	    callback = function(lol : boolean)
	        esp_toggles.Health = lol
	    end
    })

    section:AddToggle({
	    enabled = true,
	    text = "Tool ESP",
	    flag = "Tool_ESP_Enabled",
	    tooltip = "Sets if the current equipped tool of enemy character is shown.",
	    risky = false,
	    callback = function(lol : boolean)
	        esp_toggles.Tool = lol
	    end
    })
end

function setup2(section)

end

function self.init(tabs, window)
    local tab = window:AddTab("Visual")
    tabs["visual"] = tab

    local section1 = tab:AddSection("Toggles", 1)
    local section2 = tab:AddSection("Customization")

    setup1(section1)
    setup2(section2)
end

return self