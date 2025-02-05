-- ServerScript (ใส่ใน ServerScriptService)
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Webhook_URL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"

local RemoteEvent = Instance.new("RemoteEvent")
RemoteEvent.Name = "SendWebhookEvent"
RemoteEvent.Parent = ReplicatedStorage

RemoteEvent.OnServerEvent:Connect(function(player, message)
    local data = {
        ["content"] = "**🔔 Webhook แจ้งเตือนจาก: **" .. player.Name .. "\n" .. message
    }

   local success, response = pcall(function()
        return HttpService:PostAsync(Webhook_URL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)

   if success then
        print("✅ ส่งข้อมูลสำเร็จ!")
    else
        warn("❌ ส่งไม่สำเร็จ: " .. tostring(response))
    end
end)

-- LocalScript (UI & การเรียกใช้ RemoteEvent)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RemoteEvent = ReplicatedStorage:WaitForChild("SendWebhookEvent")

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

TestButton.MouseButton1Click:Connect(function()
    TestButton.Text = "⏳ กำลังส่ง..."
    RemoteEvent:FireServer("🔧 ทดสอบ Webhook: การส่งข้อความสำเร็จ ✅")
end)
