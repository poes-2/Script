local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Webhook URL ของคุณ
local webhookUrl = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"

-- ฟังก์ชันส่ง Webhook
local function sendWebhook(player, itemName)
    local data = {
        username = "Roblox Webhook",
        embeds = {
            {
                title = player.Name .. " ได้รับไอเทม!",
                description = "🎁 ไอเทมที่ได้รับ: **" .. itemName .. "**",
                color = 65280  -- สีเขียว
            }
        }
    }
    
    local jsonData = HttpService:JSONEncode(data)
    local success, response = pcall(function()
        return HttpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("✅ ส่ง Webhook สำเร็จ: " .. response)
    else
        warn("❌ ส่ง Webhook ล้มเหลว: " .. tostring(response))
    end
end

-- ตรวจจับ UI และดึงชื่อไอเทม
local function onItemReceived(player, gui)
    local itemTextLabel = gui:FindFirstChild("ItemNameLabel") -- เปลี่ยนเป็นชื่อจริงของ TextLabel ใน UI

    if itemTextLabel and itemTextLabel:IsA("TextLabel") then
        local itemName = itemTextLabel.Text
        print(player.Name .. " ได้รับไอเทม: " .. itemName)

        -- ส่ง Webhook เมื่อพบชื่อไอเทม
        sendWebhook(player, itemName)
    end
end

-- เชื่อมโยงกับ UI เมื่อผู้เล่นเข้าเกม
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(5)  -- รอให้ UI โหลด

        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            local rewardUI = playerGui:FindFirstChild("RewardScreen")  -- เปลี่ยนเป็นชื่อจริงของ UI
            if rewardUI then
                rewardUI:GetPropertyChangedSignal("Enabled"):Connect(function()
                    if rewardUI.Enabled then
                        onItemReceived(player, rewardUI)
                    end
                end)
            end
        end
    end)
end)
