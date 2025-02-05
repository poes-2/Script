local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Webhook_URL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"

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

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
ToggleButton.Text = "👁️ ซ่อน UI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 16
ToggleButton.Parent = MainFrame

-- ฟังก์ชันส่ง Webhook
function sendDiscordMessage(message)
    local jsonData = HttpService:JSONEncode({["content"] = message})
    local success, response = pcall(function()
        return HttpService:PostAsync(Webhook_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)
    
    if success then
        print("✅ ส่งข้อมูลสำเร็จ!")
    else
        warn("❌ ส่งไม่สำเร็จ! ข้อผิดพลาด: " .. tostring(response))
    end
end

-- ฟังก์ชันทดสอบ Webhook
TestButton.MouseButton1Click:Connect(function()
    sendDiscordMessage("✅ ทดสอบ Webhook สำเร็จ!")
end)

-- ฟังก์ชันปิด/เปิด UI
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleButton.Text = MainFrame.Visible and "👁️ ซ่อน UI" or "👁️ แสดง UI"
end)

-- ฟังก์ชันส่งข้อมูลไอเทมทุก 10 นาที
spawn(function()
    while true do
        wait(600) -- รอ 10 นาที
        local inventory = "\n"
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            inventory = inventory .. "- " .. item.Name .. "\n"
        end
        sendDiscordMessage("📦 **รายการไอเทมของคุณ:** " .. inventory)
    end
end)

print("✅ สคริปต์พร้อมใช้งาน! UI ควรจะแสดงแล้ว")
