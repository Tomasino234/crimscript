local self = {}
local library

local RunService = game:GetService("RunService")

-- visual tab

-- callbacks

function colorMode()
end

------------
-- visual variables --

local highlight_key = "hehaeiofjeoiagjeaxckl"
local cham_transparency = 0.65
local cham_color = Color3.new(1, 0.403921, 0.403921)
local cham_color_mode = "ColorPicker"
local esp_enabled = false
local esp_toggles = {
    Chams = false,
    Health = false,
    Tool = false,
    Names = false,
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
	    text = "Names",
	    flag = "Names_Enabled",
	    tooltip = "Sets if enemy names are rendered.",
	    risky = false,
	    callback = function(lol : boolean)
	        esp_toggles.Names = lol
	    end
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
    local color_picker = section:AddColor({
        enabled = true,
        text = "ESP Chams Color",
        flag = "cham_color",
        tooltip = "Sets the cham color",
        color = cham_color,
        trans = 0,
        open = false,
        callback = function(color, transparency)
            cham_color = color
            cham_transparency = transparency
        end
    })

    local cham_transparency = section:AddSlider({
        enabled = false, 
	    text = "Cham Transparency", 
	    flag = 'cham_trans', 
	    suffix = "", 
	    value = 0.5,
	    min = 0, 
	    max = 0.999,
	    increment = 0.01,
	    tooltip = "Sets the transparency of the chams, only shows up if color picker is not enabled. Use color picker for transparency if you're using it.",
	    risky = false,
	    callback = function(v) 
	    	cham_transparency = v
	    end
    })

    section:AddList({
	    enabled = true,
	    text = "Chams Color Mode",
	    flag = "cham_color_mode",
	    multi = false,
	    tooltip = "Changes the mode of the cham color.",
        risky = false,
        dragging = false,
        focused = false,
    	value = "ColorPicker",
    	values = {
    		"Health",
    		"ColorPicker",
    		"Rainbow (WIP)"
    	},
	    callback = function(v)
	        if v == "ColorPicker" and not color_picker.enabled then
                color_picker.enabled = true
                cham_transparency.enabled = false

                cham_color_mode = "ColorPicker"
            elseif v ~= "ColorPicker" then
                color_picker.enabled = false
                cham_transparency.enabled = true

                cham_color_mode = v
            end
	    end
    })
end

function getCharacters()
    local list = {}


    return list
end

function getChamColor(humanoid)
    if cham_color_mode == "ColorPicker" then
        return cham_color
    elseif cham_color_mode == "Health" then
        local num = math.clamp(humanoid.Health/humanoid.MaxHealth, 0, 1)
        return num
    end
end

local chams = {}
function step(dt)
    if esp_enabled then
        local CharacterList = {}
        for _, v : Humanoid in workspace:GetDescendants() do
           if v:IsA("Humanoid") then
                local Character = v.Parent
                CharacterList[Character.Name] = Character
            end
        end

        for _, Character : Model in CharacterList do
            if not Character:FindFirstChild(highlight_key) and esp_toggles.Chams then
                local cham = Instance.new("Highlight", Character)
                cham.FillColor = getChamColor(Character.Humanoid)
                cham.OutlineTransparency = 1
                cham.FillTransparency = cham_transparency

                table.insert(chams, cham)
            end
        end

        if esp_toggles.Chams ~= true and chams[1] ~= nil then
            for _, v in chams do
                v:Destroy()
            end
        elseif esp_toggles.Chams == true then
            for _, v:Highlight in chams do
                v.FillColor = getChamColor(v.Parent.Humanoid)
            end
        end
    else
        if chams[1] ~= nil then
            for _, v in chams do
                v:Destroy()
            end
        end
    end
end

function self.init(tabs, window, l)
    library = l

    local tab = window:AddTab("Visual")
    tabs["visual"] = tab

    local section1 = tab:AddSection("Toggles", 1)
    local section2 = tab:AddSection("Customization", 2)

    setup1(section1)
    setup2(section2)

    RunService.RenderStepped:Connect(step)
end

return self