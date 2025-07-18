local library : table = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tomasino234/crimscript/refs/heads/main/uilib.lua"))()
library:init()

-- modules

local mod_visual : table = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tomasino234/crimscript/refs/heads/main/main/visual.lua"))()

-- main
local Window = library.NewWindow({
    title = "femWare v2 (UNOFFICIAL)",
    size = UDim2.new(0, 525, 0, 650),
})

local tabs = {
    Settings = library:CreateSettingsTab(Window)
}

mod_visual.init(tabs, library)

print(tabs)