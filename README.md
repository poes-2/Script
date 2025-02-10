local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- ใส่ Webhook URL ของคุณ
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

-- ตรวจจับ UI และอ่านชื่อไอเทม
local function onRewardScreenOpened(player)
    local playerGui = player:WaitForChild("PlayerGui", 10) -- รอให้ PlayerGui โหลด (สูงสุด 10 วินาที)
    if not playerGui then
        warn("⚠️ ไม่พบ PlayerGui สำหรับ " .. player.Name)
        return
    end

    local rewardUI = playerGui:WaitForChild("RewardScreen", 10) -- เปลี่ยนเป็นชื่อ UI จริงของคุณ
    if not rewardUI then
        warn("⚠️ ไม่พบ RewardScreen สำหรับ " .. player.Name)
        return
    end

    local itemTextLabel = rewardUI:WaitForChild("ItemNameLabel", 10) -- เปลี่ยนเป็นชื่อ TextLabel จริงของคุณ
    if not itemTextLabel then
        warn("⚠️ ไม่พบ ItemNameLabel สำหรับ " .. player.Name)
        return
    end

    -- เมื่อ TextLabel เปลี่ยนค่า ให้ส่ง Webhook
    itemTextLabel:GetPropertyChangedSignal("Text"):Connect(function()
        local itemName = itemTextLabel.Text
        if itemName and itemName ~= "" then
            print("📢 " .. player.Name .. " ได้รับไอเทม: " .. itemName)
            sendWebhook(player, itemName)
        end
    end)
end

-- ผูกฟังก์ชันกับการเข้าของผู้เล่น
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(5) -- รอโหลดตัวละคร
        onRewardScreenOpened(player)
    end)
end)
