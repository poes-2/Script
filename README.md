local WebhookURL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"
local http_request = http_request or request or syn.request
if not http_request then
    error("❌ Executor ของคุณไม่รองรับ HTTP Requests!")
end

-- ตัวแปรเช็คสถานะเกม
local gameEnded = false

-- 📌 ฟังก์ชันส่งข้อความ Webhook
local function sendWebhookMessage(username, level, matchDMG, wave, result, rewards)
    local data = {
        ["embeds"] = {{
            ["title"] = "Anime Adventures - Match Result",
            ["color"] = (result == "VICTORY") and 5814783 or 16711680,
            ["fields"] = {
                {["name"] = "👤 User", ["value"] = username, ["inline"] = true},
                {["name"] = "🔢 Level", ["value"] = tostring(level), ["inline"] = true},
                {["name"] = "🗡️ Match DMG", ["value"] = tostring(matchDMG) .. "M", ["inline"] = true},
                {["name"] = "⏳ Wave", ["value"] = tostring(wave), ["inline"] = true},
                {["name"] = "🏆 Result", ["value"] = "**" .. result .. "**", ["inline"] = true},
                {["name"] = "🎁 Rewards", ["value"] = rewards}
            }
        }}
    }

    local success, response = pcall(function()
        return http_request({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)

    if success then
        print("✅ ส่งข้อความสำเร็จ!")
    else
        warn("❌ ส่งข้อความไม่สำเร็จ: " .. tostring(response))
    end
end

-- 📌 ฟังก์ชันดึงข้อมูลจากเกม
local function getGameStats()
    local player = game.Players.LocalPlayer
    local damage, wave, result, rewards = "0", "0", "UNKNOWN", "None"

    -- เช็คค่าจาก Stats
    if player:FindFirstChild("Stats") then
        damage = player.Stats:FindFirstChild("Damage") and player.Stats.Damage.Value or "0"
        wave = player.Stats:FindFirstChild("Wave") and player.Stats.Wave.Value or "0"
    end

    -- เช็ค UI ของเกม
    if player:FindFirstChild("PlayerGui") then
        for _, gui in pairs(player.PlayerGui:GetDescendants()) do
            if gui:IsA("TextLabel") then
                if gui.Text == "VICTORY" or gui.Text == "DEFEAT" then
                    result = gui.Text
                end
            end
        end
    end

    -- เช็ครางวัลจาก Inventory
    if player:FindFirstChild("Inventory") then
        rewards = player.Inventory:FindFirstChild("LastReward") and player.Inventory.LastReward.Value or "None"
    end

    return damage, wave, result, rewards
end

-- 📌 ฟังก์ชันตรวจสอบว่าเกมจบหรือยัง
local function detectGameState()
    while wait(2) do
        if gameEnded then return end  -- ถ้าเกมจบแล้ว ให้หยุดทำงาน

        local player = game.Players.LocalPlayer
        if not player then return end

        local damage, wave, result, rewards = getGameStats()

        -- ตรวจจับสถานะเกม
        if (result == "VICTORY" or result == "DEFEAT") and not gameEnded then
            gameEnded = true  -- ป้องกันการส่งข้อความซ้ำ

            local username = player.Name
            local level = player:FindFirstChild("Level") and player.Level.Value or "N/A"

            sendWebhookMessage(username, level, damage, wave, result, rewards)

            wait(10)  
        end
    end
end

-- 🔄 เริ่มตรวจสอบ
spawn(detectGameState)
