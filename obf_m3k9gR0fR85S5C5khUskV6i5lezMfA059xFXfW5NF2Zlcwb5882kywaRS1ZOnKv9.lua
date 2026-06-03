




local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()


local httpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local SaveManager = {} do
    SaveManager.Folder = "FluentSettings"
    SaveManager.Ignore = {}
    

    local ConfigName = player.Name

    SaveManager.Parser = {
        Toggle = {
            Save = function(idx, object) return { type = "Toggle", idx = idx, value = object.Value } end,
            Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
        },
        Slider = {
            Save = function(idx, object) return { type = "Slider", idx = idx, value = tostring(object.Value) } end,
            Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
        },
        Dropdown = {
            Save = function(idx, object) return { type = "Dropdown", idx = idx, value = object.Value, multi = object.Multi } end,
            Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
        },
        Colorpicker = {
            Save = function(idx, object) return { type = "Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency } end,
            Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency) end end,
        },
        Keybind = {
            Save = function(idx, object) return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value } end,
            Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.key, data.mode) end end,
        },
        Input = {
            Save = function(idx, object) return { type = "Input", idx = idx, text = object.Value } end,
            Load = function(idx, data) if SaveManager.Options[idx] and type(data.text) == "string" then SaveManager.Options[idx]:SetValue(data.text) end end,
        },
    }

    function SaveManager:SetIgnoreIndexes(list)
        for _, key in next, list do self.Ignore[key] = true end
    end

    function SaveManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

   
    function SaveManager:AutoSave()
        return self:Save(ConfigName)
    end

    function SaveManager:Save(name)
        if (not name) then return false, "no config file is selected" end
        local fullPath = self.Folder .. "/settings/" .. name .. ".json"

        local data = { objects = {} }
        for idx, option in next, SaveManager.Options do
            if not self.Parser[option.Type] then continue end
            if self.Ignore[idx] then continue end
            table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
        end	

        local success, encoded = pcall(httpService.JSONEncode, httpService, data)
        if not success then return false, "failed to encode data" end

        writefile(fullPath, encoded)
        return true
    end

    function SaveManager:Load(name)
        name = name or ConfigName 
        local file = self.Folder .. "/settings/" .. name .. ".json"
        if not isfile(file) then return false, "invalid file" end

        local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
        if not success then return false, "decode error" end

        for _, option in next, decoded.objects do
            if self.Parser[option.type] then
                task.spawn(function() self.Parser[option.type].Load(option.idx, option) end)
            end
        end
        return true
    end

    function SaveManager:BuildFolderTree()
        local paths = { self.Folder, self.Folder .. "/settings" }
        for i = 1, #paths do
            if not isfolder(paths[i]) then makefolder(paths[i]) end
        end
    end

    function SaveManager:SetLibrary(library)
        self.Library = library
        self.Options = library.Options
    end

    function SaveManager:LoadUserConfig()
        local success, err = self:Load(ConfigName)
        if success then
            self.Library:Notify({
                Title = "Interface",
                Content = "Auto Loader",
                SubContent = "Loaded settings for " .. ConfigName,
                Duration = 5
            })
        end
    end

   
    function SaveManager:InitializeAutoSave(interval)
        task.spawn(function()
            while task.wait(interval or 30) do
                self:AutoSave()
            end
        end)
    end

    SaveManager:BuildFolderTree()
end

local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local function getProfileThumbnail()
    local success, content = pcall(function()
        local userId = player.UserId
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size100x100
        return game:GetService("Players"):GetUserThumbnailAsync(userId, thumbType, thumbSize)
    end)
    return success and content or "rbxassetid://0"
end


local Window = Fluent:CreateWindow({
    Title = "stand",
    SubTitle = "by anucha 🍋  ",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Custom UI for Profile and Toggle
local function setupCustomUI(window)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GardenHorizoneCustomUI"
    screenGui.DisplayOrder = 999
    
    local parent = (gethui and gethui()) or game:GetService("CoreGui") or player:WaitForChild("PlayerGui")
    screenGui.Parent = parent

    -- Toggle Button
    local toggleButton = Instance.new("ImageButton")
    toggleButton.Name = "MenuToggle"
    toggleButton.Parent = screenGui
    toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.new(0, 15, 0.2, 0) -- Slightly higher
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Image = "rbxassetid://81617068776053" -- List/Menu icon
    toggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toggleButton

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Parent = toggleButton

    toggleButton.MouseButton1Click:Connect(function()
        if window then
            window:Minimize()
        end
    end)

    -- Profile Section (Robust Discovery)
    task.spawn(function()
        local sidebar
        local start = tick()
        
        -- Enhanced search for sidebar
        while not sidebar and tick() - start < 15 do
            if window and window.Root then
                -- Try finding by common name or class
                sidebar = window.Root:FindFirstChild("Sidebar", true) 
                
                if not sidebar then
                    -- Fallback: Look for any ScrollingFrame that might be the sidebar
                    for _, v in pairs(window.Root:GetDescendants()) do
                        if v:IsA("ScrollingFrame") and v.Name == "Sidebar" then
                            sidebar = v
                            break
                        end
                    end
                end
            end
            if not sidebar then task.wait(0.5) end
        end

        if sidebar then
            if sidebar:FindFirstChild("UserProfile") then return end

            local profileFrame = Instance.new("Frame")
            profileFrame.Name = "UserProfile"
            profileFrame.Parent = sidebar
            profileFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            profileFrame.BackgroundTransparency = 0.1
            profileFrame.BorderSizePixel = 0
            -- Position it at the bottom of the sidebar
            profileFrame.Position = UDim2.new(0, 10, 1, -70)
            profileFrame.Size = UDim2.new(1, -20, 0, 60)
            profileFrame.ZIndex = 500
            
            local pCorner = Instance.new("UICorner")
            pCorner.CornerRadius = UDim.new(0, 12)
            pCorner.Parent = profileFrame

            local pStroke = Instance.new("UIStroke")
            pStroke.Thickness = 1
            pStroke.Color = Color3.fromRGB(100, 100, 100)
            pStroke.Parent = profileFrame

            local profileImage = Instance.new("ImageLabel")
            profileImage.Name = "Avatar"
            profileImage.Parent = profileFrame
            profileImage.BackgroundTransparency = 1
            profileImage.Position = UDim2.new(0, 10, 0, 10)
            profileImage.Size = UDim2.new(0, 40, 0, 40)
            profileImage.Image = getProfileThumbnail()
            profileImage.ZIndex = 501
            
            local iCorner = Instance.new("UICorner")
            iCorner.CornerRadius = UDim.new(1, 0)
            iCorner.Parent = profileImage

            local profileName = Instance.new("TextLabel")
            profileName.Name = "UsernameLabel"
            profileName.Parent = profileFrame
            profileName.BackgroundTransparency = 1
            profileName.Position = UDim2.new(0, 60, 0, 0)
            profileName.Size = UDim2.new(1, -65, 1, 0)
            profileName.Font = Enum.Font.GothamBold
            profileName.Text = player.DisplayName or player.Name
            profileName.TextColor3 = Color3.fromRGB(255, 255, 255)
            profileName.TextSize = 13
            profileName.TextXAlignment = Enum.TextXAlignment.Left
            profileName.TextTruncate = Enum.TextTruncate.AtEnd
            profileName.ZIndex = 501
        end
    end)
end
setupCustomUI(Window)

local Tabs = {
    Farm = Window:AddTab({ Title = "Farm", Icon = "Sword" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options


local function GetMyRoot()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end


_G.Autotp = false

    local function Teleport(cf)
        local root = GetMyRoot()
        if root then
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            root.Anchored = true
            root.CFrame = (typeof(cf) == "Vector3" and CFrame.new(cf) or cf)
            task.wait() 
            root.Anchored = false
        end
    end

local function FRAM(target)
    local enemies = workspace:FindFirstChild("Enemies")
    local root = GetMyRoot()
    if not enemies or not root or not target then
        return
    end

    local targetName = tostring(target)
    
    -- First try the selected target
    for _, enemy in ipairs(enemies:GetChildren()) do
        if enemy.Name == targetName then
            local pivot = enemy:GetPivot()
            if pivot then
                local distrig = (root.Position - pivot.Position).Magnitude
                if distrig > 5 then
                    Teleport(pivot + Vector3.new(0, 1, 0))
                    print("teleport to " .. enemy.Name)
                end
            end
            return
        end
    end

    -- Fallback: if selected target is gone, try the previous monster ID(s)
    local targetIndex = tonumber(targetName)
    if targetIndex then
        for i = targetIndex - 1, 1, -1 do
            local fallbackName = tostring(i)
            for _, enemy in ipairs(enemies:GetChildren()) do
                if enemy.Name == fallbackName then
                    local pivot = enemy:GetPivot()
                    if pivot then
                        local distrig = (root.Position - pivot.Position).Magnitude
                        if distrig > 5 then
                            Teleport(pivot + Vector3.new(0, 1, 0))
                            print("teleport to " .. enemy.Name)
                        end
                    end
                    return
                end
            end
        end
    end
end


local SkillDropdown = Tabs.Farm:AddDropdown("SkillDropdown", {
        Title = "Auto tp monter",
        Description = "เลือกมอน",
        Values = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17"},
        Multi = false,
        Default = "1",
    })  



Tabs.Farm:AddToggle("Autotp", {Title = "Auto tp", Description = " teleport ไปหา มอน", Default = false, Callback = function(v) _G.Autotp = v end})

task.spawn(function()
    while task.wait(1) do
        if _G.Autotp then
           
            FRAM(Options.SkillDropdown.Value)
            
        end
       
    end
end)














SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("AnimeApocalypse")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadUserConfig()
SaveManager:InitializeAutoSave(5)





