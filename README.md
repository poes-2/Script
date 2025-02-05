local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Webhook_URL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"

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
TestButton.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
ToggleButton.Text = "👁️ ซ่อน UI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Parent = MainFrame

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleButton.Text = MainFrame.Visible and "👁️ ซ่อน UI" or "👁️ แสดง UI"
end)

function sendDiscordMessage(message)
    local data = {
        ["username"] = "Anime Adventures Bot",
        ["content"] = message
    }
    local jsonData = HttpService:JSONEncode(data)
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
    sendDiscordMessage("✅ ทดสอบ Webhook สำเร็จ!")
end)

spawn(function()
    while wait(600) do -- ทุก 10 นาที
        local items = {}
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            table.insert(items, item.Name)
        end
        local itemText = #items > 0 and table.concat(items, ", ") or "ไม่มีไอเทม"
        sendDiscordMessage("🎒 ไอเทมของ " .. LocalPlayer.Name .. "\n" .. itemText)
    end
end)

print("✅ สคริปต์พร้อมใช้งาน! UI ควรจะแสดงแล้ว")
