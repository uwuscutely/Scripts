-- UI by Inori, maintained by Wally
local repo = 'https://raw.githubusercontent.com/uwuscutely/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo..'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo..'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo..'addons/SaveManager.lua'))()

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = game:GetService("Players").LocalPlayer
local Humanoid = Player.Character.HumanoidRootPart
local PlayerGui = Player:WaitForChild("PlayerGui")

local AcceptQuest = ReplicatedStorage.Remotes.Quests:WaitForChild("AcceptQuest")
local AbandonQuest = ReplicatedStorage.Remotes.Quests:WaitForChild("AbandonQuest")
local CompleteQuest = ReplicatedStorage.Remotes.Quests:WaitForChild("CompleteQuest")

ver = '1.0.0'

Library:Notify('Loading Swicing Thwough Youw Cabbwge v'..ver, 5)

local Window = Library:CreateWindow({
    Title = 'UwU | Swicing Thwough Youw Cabbwge v'..ver,
    Center = true, 
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Auto Swing')

LeftGroupBox:AddToggle('AutoSwing', {
    Text = 'Auto Swing',
    Default = false,
    Tooltip = 'Automaticawwy swings youw swowd (swightwy quickew than the gawme\'s cwappy owne).',
}):AddKeyPicker('AutoSwingKey',{
    Default = 'C',
    SyncToggleState = true, 
    Mode = 'Toggle',
    Text = 'Auto Swing', -- Text to display in the keybind menu
    NoUI = false, -- Set to true if you want to hide from the Keybind menu,
})

LeftGroupBox:AddToggle('AutoCoinQuest', {
    Text = 'Auto Coin Quest',
    Default = false,
    Tooltip = 'Expwoit the shit out of quest bc shitty devs.',
})

Toggles.AutoSwing:OnChanged(function()
    while Toggles.AutoSwing.Value do
        local mouse = UserInputService:GetMouseLocation()
        VirtualInputManager:SendMouseButtonEvent(mouse.x, mouse.y, 0, true, game, 0)
        task.wait()
        VirtualInputManager:SendMouseButtonEvent(mouse.x, mouse.y, 0, false, game, 0)
    end
end)

Toggles.AutoCoinQuest:OnChanged(function()
    while Toggles.AutoCoinQuest.Value do
        AbandonQuest:InvokeServer()
        task.wait()
        AcceptQuest:InvokeServer()
    
        if PlayerGui.Popups.QuestProgress.Frame.TextLabel.Text:match("Coins") then
            while true do
                Humanoid.CFrame = CFrame.new(-569.3, 130.3, 150.8)
                task.wait(1)
                Humanoid.CFrame = CFrame.new(-579, 126, 162)

                if PlayerGui.Popups.QuestProgress.Frame.TextLabel.Text:match("Completed") then
                    CompleteQuest:InvokeServer()
                    break
                end
                task.wait(0.5)
            end
        end
    end
end)

Library:SetWatermarkVisibility(true)
Library:SetWatermark('Meow Meow UwU ^_^')

Library.KeybindFrame.Visible = false

Library:OnUnload(function()
    print('Unwoaded!')
    Library.Unloaded = true
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload UI', function() Library:Unload() end)
MenuGroup:AddLabel('Menu Toggle'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu Toggle' })
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:SetFolder('RawrX3Nuzzles')
SaveManager:SetFolder('RawrX3Nuzzles/Bullshit')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
Library:Notify('Loaded Swicing Thwough Youw Cabbwge v'..ver..'! Meow meow ^-^', 5)

-- Update checker from https://github.com/EdgeIY/infiniteyield
task.spawn(function()
    Library:Notify('Running update check!', 2)
    while true do
        if pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/uwuscutely/Scripts/main/Version'))() end) then
            if ver ~= BSVersion then
                Library:Notify('Your current version of Swicing Thwough Youw Cabbwge is outdated!\n\nYour version: '..ver..'\nLatest version: '..BSVersion..'\n\nGrab the latest version by re-executing the script!', 25)
            end
        end
        task.wait(30)
    end
end)

if pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/uwuscutely/Scripts/main/Version'))() end) then
    if ver == BSVersion then
        Library:Notify('You\'re running the latest verion of Swicing Thwough Youw Cabbwge!', 5)
    end
end

-- RGB gradient from https://github.com/violin-suzutsuki/LinoriaLib
Toggles.Rainbow:OnChanged(function()
    task.spawn(function()
        while Toggles.Rainbow.Value do
            task.wait()
            local Registry = Window.Holder.Visible and Library.Registry or Library.HudRegistry

            for Idx, Object in next, Library.Registry do
                for Property, ColorIdx in next, Object.Properties do
                    if ColorIdx == 'AccentColor' or ColorIdx == 'AccentColorDark' then
                        local Instance = Object.Instance
                        local yPos = Instance.AbsolutePosition.Y

                        local Mapped = Library:MapValue(yPos, 0, 1080, 0, 0.5) * 1.5
                        local Color = Color3.fromHSV((Library.CurrentRainbowHue - Mapped) % 1, 0.8, 1)

                        if ColorIdx == 'AccentColorDark' then
                            Color = Library:GetDarkerColor(Color)
                        end

                        Instance[Property] = Color
                    end
                end
            end
        end

        if not Toggles.Rainbow.Value then
            ThemeManager:UpdateTheme()
        end
    end)
end)
