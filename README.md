local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Webhook_URL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA" -- แทนที่ด้วย Webhook ของคุณ

local startTime = os.time() -- เริ่มจับเวลา

local function getCharacterInfo()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Webhook_URL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA" -- ใส่ Webhook ของคุณที่นี่

local startTime = os.time() -- เริ่มจับเวลา

-- สร้าง UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Anime Adventure Webhook"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

local TestButton = Instance.new("TextButton")
TestButton.Size = UDim2.new(0.8, 0, 0, 40)
TestButton.Position = UDim2.new(0.1, 0, 0.3, 0)
TestButton.Text = "📩 ทดสอบ Webhook"
TestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TestButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
TestButton.Font = Enum.Font.Gotham
TestButton.TextSize = 16
TestButton.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
ToggleButton.Text = "👁️ ซ่อน UI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 16
ToggleButton.Parent = MainFrame

-- ฟังก์ชันทดสอบ Webhook
TestButton.MouseButton1Click:Connect(function()
    sendDiscordMessage()
    TestButton.Text = "✅ ส่งสำเร็จ!"
    wait(2)
    TestButton.Text = "📩 ทดสอบ Webhook"
end)

-- ฟังก์ชันปิด/เปิด UI
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleButton.Text = MainFrame.Visible and "👁️ ซ่อน UI" or "👁️ แสดง UI"
end)

-- ฟังก์ชันดึงข้อมูลตัวละคร
local function getCharacterInfo()
    local characters = {}
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("Model") then
            local level = "??" -- ค่าเริ่มต้น
            for _, stat in pairs(v:GetChildren()) do
                if stat:IsA("IntValue") and stat.Name == "Level" then
                    level = stat.Value
                end
            end
            table.insert(characters, "- " .. v.Name .. " (Lv " .. level .. ")")
        end
    end
    return #characters > 0 and table.concat(characters, "\n") or "ไม่พบข้อมูล"
end

-- ฟังก์ชันดึงของรางวัล
local function getRewards()
    local rewards = {}
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") and string.find(v.Text, "Reward:") then
            table.insert(rewards, v.Text)
        end
    end
    return #rewards > 0 and table.concat(rewards, "\n") or "ไม่มีของรางวัล"
end

-- ฟังก์ชันดึงชื่อด่าน
local function getMapName()
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") and string.find(v.Text, "Map:") then
            return v.Text:gsub("Map: ", "")
        end
    end
    return "Unknown"
end

-- ฟังก์ชันดึงสถิติผู้เล่น
local function getPlayerStats()
    local stats = {
        damage = "ไม่พบข้อมูล",
        kills = "ไม่พบข้อมูล",
        waves = "ไม่พบข้อมูล"
    }
    
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") then
            if string.find(v.Text, "Damage:") then
                stats.damage = v.Text:gsub("Damage: ", "")
            elseif string.find(v.Text, "Kills:") then
                stats.kills = v.Text:gsub("Kills: ", "")
            elseif string.find(v.Text, "Wave:") then
                stats.waves = v.Text:gsub("Wave: ", "")
            end
        end
    end
    
    return stats
end

-- ฟังก์ชันดึงข้อมูลผู้เล่น
local function getPlayerInfo()
    return {
        username = LocalPlayer.Name, -- ชื่อผู้เล่น Roblox
        userId = LocalPlayer.UserId, -- ID ผู้เล่น
        avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
    }
end

-- ฟังก์ชันส่ง Webhook ไปยัง Discord
function sendDiscordMessage()
    local endTime = os.time()
    local elapsedTime = endTime - startTime
    local playerInfo = getPlayerInfo()
    local stats = getPlayerStats()

    local data = {
        ["username"] = "Anime Adventures Bot",
        ["avatar_url"] = playerInfo.avatarUrl,
        ["embeds"] = {{
            ["title"] = "✅ **Mission Complete!** 🎉",
            ["color"] = 65280,
            ["thumbnail"] = {["url"] = playerInfo.avatarUrl},
            ["fields"] = {
                {["name"] = "👤 ผู้เล่น", ["value"] = playerInfo.username .. " (ID: " .. playerInfo.userId .. ")", ["inline"] = false},
                {["name"] = "📍 ด่านที่เล่น", ["value"] = getMapName(), ["inline"] = true},
                {["name"] = "🕒 ใช้เวลา", ["value"] = elapsedTime .. " วินาที", ["inline"] = true},
                {["name"] = "🎭 ตัวละครที่ใช้", ["value"] = getCharacterInfo(), ["inline"] = false},
                {["name"] = "⚔️ Damage", ["value"] = stats.damage, ["inline"] = true},
                {["name"] = "💀 Kills", ["value"] = stats.kills, ["inline"] = true},
                {["name"] = "🌊 จำนวน Wave", ["value"] = stats.waves, ["inline"] = true},
                {["name"] = "🎁 ของที่ได้รับ", ["value"] = getRewards(), ["inline"] = false}
            }
        }}
    }

    local jsonData = HttpService:JSONEncode(data)
    HttpService:PostAsync(Webhook_URL, jsonData, Enum.HttpContentType.ApplicationJson)
end

-- ตรวจจับการชนะด่าน
local function detectMissionComplete()
    while wait(1) do
        for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and string.find(v.Text, "Victory") then
                sendDiscordMessage()
                print("✅ ส่งข้อมูลไปยัง Discord แล้ว!")
                return
            end
        end
    end
end

print("✅ สคริปต์พร้อมใช้งาน!")
detectMissionComplete()
