local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"  -- ใส่ Webhook URL

-- ฟังก์ชันส่งข้อมูลไปยัง Discord Webhook
local function sendToDiscord(player, taskData)
    local embed = {
        ["title"] = "📩 ส่งานฟาม",
        ["color"] = 65280,  -- สีเขียว
        ["fields"] = {
            {["name"] = "👤 จ้างโดย", ["value"] = "<@"..taskData.userId..">", ["inline"] = false},
            {["name"] = "🎯 รายการฟาม", ["value"] = taskData.listFarm, ["inline"] = false},
            {["name"] = "💰 จำนวนเหรียญ", ["value"] = taskData.coinAmount, ["inline"] = false},
            {["name"] = "🎲 Death Dice", ["value"] = taskData.deathDice, ["inline"] = false}
        },
        ["footer"] = {["text"] = "ส่งโดย " .. player.Name}
    }

    local payload = {
        ["content"] = "<@"..taskData.userId..">",
        ["embeds"] = {embed}
    }

    local jsonData = HttpService:JSONEncode(payload)

    -- ส่งข้อมูลไปยัง Webhook
    local success, err = pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if not success then
        warn("❌ ไม่สามารถส่งข้อมูลไปยัง Discord:", err)
    end
end

-- UI สำหรับให้ผู้ใช้ป้อนข้อมูล (ตัวอย่าง)
local function createTaskForm(player)
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local screenGui = Instance.new("ScreenGui", playerGui)
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)

    local textBox = Instance.new("TextBox", frame)
    textBox.PlaceholderText = "พิมพ์ไอเทมหรือข้อมูลฟาม..."
    textBox.Size = UDim2.new(1, -10, 0, 30)
    textBox.Position = UDim2.new(0, 5, 0, 5)

    local submitButton = Instance.new("TextButton", frame)
    submitButton.Text = "ส่งข้อมูล"
    submitButton.Size = UDim2.new(1, -10, 0, 30)
    submitButton.Position = UDim2.new(0, 5, 0, 40)

    submitButton.MouseButton1Click:Connect(function()
        local taskData = {
            userId = player.UserId,
            listFarm = textBox.Text,
            coinAmount = "100",
            deathDice = "2"
        }
        sendToDiscord(player, taskData)
    end)
end

-- คำสั่งเปิด UI
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if message == "!ส่งงาน" then
            createTaskForm(player)
        end
    end)
end)
