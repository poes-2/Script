local WebhookURL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"
local http_request = http_request or request or syn.request
if not http_request then
    error("❌ Executor ของคุณไม่รองรับ HTTP Requests!")
end

-- ตัวแปรเก็บสถานะเกม
local gameActive = true
local gameEnded = false

-- 📌 ฟังก์ชันส่งข้อความ Webhook
function sendWebhookMessage(username, level, matchDMG, wave, result, rewards)
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

-- 📌 ตรวจจับว่าผู้เล่นอยู่ในเกมหรือไม่
local function detectGameState()
    while wait(2) do
        if not gameActive then return end  -- ถ้าเกมจบแล้ว หยุดทำงาน

        local player = game.Players.LocalPlayer
        if not player then return end

        local screenGui = player:FindFirstChild("PlayerGui")
        if screenGui then
            for _, guiObject in pairs(screenGui:GetDescendants()) do
                if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") then
                    local text = guiObject.Text:upper()

                    -- 🔍 ตรวจสอบปุ่ม "NEXT" แต่ถ้าพบมากกว่า 3 ครั้ง ให้ยืนยันว่าเกมยังไม่จบ
                    if text == "NEXT" then
                        local nextCount = 0
                        while wait(1) do
                            if guiObject.Text:upper() == "NEXT" then
                                nextCount = nextCount + 1
                            end
                            if nextCount > 3 then
                                gameEnded = false
                                return
                            end
                        end
                    end

                    -- 🏆 ตรวจจับ "VICTORY" หรือ "DEFEAT" เท่านั้น
                    if (text == "VICTORY" or text == "DEFEAT") and not gameEnded then
                        gameEnded = true  -- ป้องกันการส่งข้อความซ้ำ

                        -- 📌 ดึงข้อมูลจากเกมจริงๆ
                        local level = player:FindFirstChild("Level") and player.Level.Value or "N/A"
                        local matchDMG = player:FindFirstChild("Stats") and player.Stats:FindFirstChild("Damage") and player.Stats.Damage.Value or "0"
                        local wave = player:FindFirstChild("Stats") and player.Stats:FindFirstChild("Wave") and player.Stats.Wave.Value or "0"
                        local rewards = player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("LastReward") and player.Inventory.LastReward.Value or "None"

                        -- 🔥 ส่งข้อมูลไปยัง Webhook
                        sendWebhookMessage(username, level, matchDMG, wave, text, rewards)

                        -- หยุดตรวจสอบ
                        wait(10)  
                        gameActive = false  
                    end
                end
            end
        end
    end
end

-- 🔄 เริ่มตรวจสอบ
spawn(detectGameState)
