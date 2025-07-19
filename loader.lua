local oldNewIndex
local usedtable = {}
oldNewIndex = hookmetamethod(game, "__newindex", function(self, key, value)
    if typeof(self) == "Instance"
        and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction") or self:IsA("BindableEvent") or self:IsA("BindableFunction"))
        and key == "Name"
        and (value == "" or value == " ")
        and not usedtable[self.Name] then

        local ogname = self.Name
        
        usedtable[self.Name] = true

        task.delay(0.1, function()
            self.Name = ogname
        end)
    end

    return oldNewIndex(self, key, value)
end)

-- end of bypass

repeat
    task.wait()
until game:IsLoaded()

getgenv().Config = {
	Invite = "informant.wtf",
	Version = "0.0",
}

getgenv().luaguardvars = {
	DiscordName = "username#0000",
}

local library : table = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tomasino234/crimscript/refs/heads/main/uilib.lua"))()
library:init()

-- modules

local mod_visual : table = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tomasino234/crimscript/refs/heads/main/main/visual.lua"))()

-- main
local Window = library.NewWindow({
    title = "porn hub",
    size = UDim2.new(0, 525, 0, 650),
})

local tabs = {
    
}

mod_visual.init(tabs, Window)

tabs.settings = library:CreateSettingsTab(Window)
