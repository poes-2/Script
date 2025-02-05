local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Webhook_URL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA" -- ใส่ Webhook ของคุณ

local startTime = os.time()

-- สร้าง UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Parent = ScreenGui

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

local function sendDiscordMessage(message)
    local jsonData = HttpService:JSONEncode({
        ["content"] = message
    })

    local success, response = pcall(function()
        return HttpService:PostAsync(Webhook_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("✅ ส่งข้อมูลสำเร็จ!")
    else
        warn("❌ ส่งไม่สำเร็จ! ข้อผิดพลาด: " .. tostring(response))
    end
end

TestButton.MouseButton1Click:Connect(function()
    sendDiscordMessage("🛠 ทดสอบ Webhook: ข้อความนี้ถูกส่งจาก UI")
end)

local function sendGameStats()
    local elapsedTime = os.time() - startTime
    local playerInfo = {
        username = LocalPlayer.Name,
        userId = LocalPlayer.UserId,
        avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
    }
    
    local stats = {
        damage = "N/A",
        kills = "N/A",
        waves = "N/A"
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
    
    local data = {
        ["username"] = "Anime Adventures Bot",
        ["avatar_url"] = playerInfo.avatarUrl,
        ["embeds"] = {{
            ["title"] = "🏆 **Mission Complete!** 🎉",
            ["color"] = 65280,
            ["thumbnail"] = { ["url"] = playerInfo.avatarUrl },
            ["fields"] = {
                { ["name"] = "👤 ผู้เล่น", ["value"] = playerInfo.username .. " (ID: " .. playerInfo.userId .. ")", ["inline"] = false },
                { ["name"] = "🕒 ใช้เวลา", ["value"] = elapsedTime .. " วินาที", ["inline"] = true },
                { ["name"] = "⚔️ Damage", ["value"] = stats.damage, ["inline"] = true },
                { ["name"] = "💀 Kills", ["value"] = stats.kills, ["inline"] = true },
                { ["name"] = "🌊 จำนวน Wave", ["value"] = stats.waves, ["inline"] = true }
            }
        }}
    }

    local jsonData = HttpService:JSONEncode(data)
    
    local success, response = pcall(function()
        return HttpService:PostAsync(Webhook_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("✅ ส่งข้อมูลสำเร็จ!")
    else
        print("❌ ส่งไม่สำเร็จ: ", response)
    end
end

spawn(function()
    while wait(600) do -- ทุก 10 นาที
        sendGameStats()
    end
end)

print("✅ สคริปต์พร้อมใช้งาน! UI ควรจะแสดงแล้ว")
