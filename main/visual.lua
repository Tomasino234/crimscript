local self = {}
local library

local RunService = game:GetService("RunService")

-- visual tab

local comb = {
    "sdj",
    "djs",
    "gj",
    "men",
    "fag",
    "daq",
    "glock",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0"
}
function generateString()
    local combo = ""
    for i = 1,9 do
        combo = combo..comb[math.random(1,#comb)]
    end

    return combo
end

-- callbacks

function colorMode()
end

------------
-- visual variables --

local highlight_key = generateString()
local name_key = generateString()
local health_key = generateString()
local tool_key = generateString()
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
        callback = function(color)
            cham_color = color
        end
    })

    local cham_transparency = section:AddSlider({
        enabled = true, 
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
	        if v == "ColorPicker" then
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

function getChamColor(humanoid, bypass)
    if cham_color_mode == "ColorPicker" and not bypass then
        return cham_color
    elseif cham_color_mode == "Health" or bypass then
        local color = Color3.fromRGB(255,0,0):Lerp(Color3.fromRGB(0,255,0), humanoid.Health/humanoid.MaxHealth)
        return color
    end
end

local chams = {}
local names = {}
local healths = {}
local tools = {}
local CharacterList = {}
function step(dt)
    if esp_enabled then
        for _, v : Humanoid in workspace:GetDescendants() do
           if v:IsA("Humanoid") and CharacterList[v.Parent.Name] == nil then
                local Character = v.Parent
                CharacterList[Character.Name] = Character
            end
        end

        for _, Character : Model in CharacterList do
            if not Character:FindFirstChild(highlight_key) and esp_toggles.Chams then
                local cham = Instance.new("Highlight", Character)
                cham.Name = highlight_key
                cham.FillColor = getChamColor(Character.Humanoid)
                cham.OutlineTransparency = 1
                cham.FillTransparency = cham_transparency

                table.insert(chams, cham)
            end

            if not Character.Head:FindFirstChild(name_key) and esp_toggles.Names then
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = name_key
                billboardGui.Adornee = Character:WaitForChild("Head") 
                billboardGui.Parent = Character:WaitForChild("Head")
                billboardGui.Size = UDim2.new(0, 200, 0, 50)  
                billboardGui.StudsOffset = Vector3.new(0, 3, 0) 
                billboardGui.AlwaysOnTop = true

                local textLabel = Instance.new("TextLabel")
                textLabel.Parent = billboardGui
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) 
                textLabel.TextSize = 9
                textLabel.TextStrokeTransparency = 0
                textLabel.Text = Character.Name

                table.insert(names, billboardGui)
            end

            if not Character.Head:FindFirstChild(health_key) and esp_toggles.Health then
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = health_key
                billboardGui.Adornee = Character:WaitForChild("Head") 
                billboardGui.Parent = Character:WaitForChild("Head")
                billboardGui.Size = UDim2.new(0, 200, 0, 50)  
                billboardGui.StudsOffset = Vector3.new(0, -3, 0) 
                billboardGui.AlwaysOnTop = true

                local textLabel = Instance.new("TextLabel")
                textLabel.Parent = billboardGui
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.new(1,1,1)
                textLabel.TextSize = 9
                textLabel.TextStrokeTransparency = 0
                textLabel.Text = ("Health : %s"):format(tostring(Character.Humanoid.Health))

                table.insert(healths, billboardGui)
            end

            if not Character.Head:FindFirstChild(tool_key) and esp_toggles.Tool then
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = tool_key
                billboardGui.Adornee = Character:WaitForChild("Head") 
                billboardGui.Parent = Character:WaitForChild("Head")
                billboardGui.Size = UDim2.new(0, 200, 0, 50)  
                billboardGui.StudsOffset = Vector3.new(0, -4, 0) 
                billboardGui.AlwaysOnTop = true

                local textLabel = Instance.new("TextLabel")
                textLabel.Parent = billboardGui
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.new(1,0.6,0)
                textLabel.TextSize = 9
                textLabel.TextStrokeTransparency = 0
                textLabel.Text = "None"

                table.insert(tools, billboardGui)
            end
        end

        if esp_toggles.Chams ~= true then
            for _, v in chams do
                v:Destroy()
            end
        elseif esp_toggles.Chams == true then
            for _, v:Highlight in chams do
                v.FillColor = getChamColor(v.Parent.Humanoid)
                v.FillTransparency = cham_transparency
            end
        end

        if esp_toggles.Names ~= true then
            for _, v in names do
                v:Destroy()
            end
        end

        if esp_toggles.Health ~= true then
            for _, v in healths do
                v:Destroy()
            end
        elseif esp_toggles.Health then
            for _, v : BillboardGui in healths do
                if not v:FindFirstChildWhichIsA("TextLabel") then
                    v:Destroy()

                    continue
                end

                local text : TextLabel = v.TextLabel
                text.TextColor3 = getChamColor(v.Parent.Parent.Humanoid, true)
                text.Text = ("Health : %s"):format(tostring(v.Parent.Parent.Humanoid.Health))
            end
        end

        if esp_toggles.Tool ~= true then
            for _, v in tools do
                v:Destroy()
            end
        elseif esp_toggles.Tool then
            for _, v : BillboardGui in tools do
                local text : TextLabel = v.TextLabel
                if v.Parent.Parent:FindFirstChildWhichIsA("Tool") then
                    text.Text = v.Parent.Parent:FindFirstAncestorWhichIsA("Tool")
                else
                    text.Text = "None"
                end
            end
        end
    else

        for _, v in chams do
            v:Destroy()
        end

        for _, v in names do
            v:Destroy()
        end

        for _, v in healths do
            v:Destroy()
        end

        for _, v in tools do
            v:Destroy()
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