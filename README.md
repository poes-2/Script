local WebhookURL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"
local http_request = http_request or request or syn.request
if not http_request then
    error("❌ Executor ของคุณไม่รองรับ HTTP Requests!")
end

-- ฟังก์ชันส่งข้อความไปยัง Webhook
function sendWebhookMessage(username, level, matchDMG, wave, result, rewards)
    local data = {
        ["embeds"] = {{
            ["title"] = "Anime Adventures - Match Result",
            ["color"] = 5814783,
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

-- 📌 ฟังก์ชันตรวจจับข้อความ "NEXT" บนหน้าจอ
local function checkNextText()
    local player = game.Players.LocalPlayer
    if not player then return end

    local screenGui = player:FindFirstChild("PlayerGui") -- ค้นหา GUI ของผู้เล่น
    if screenGui then
        for _, guiObject in pairs(screenGui:GetDescendants()) do
            if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") then
                if string.find(guiObject.Text, "NEXT") then
                    print("🔍 พบข้อความ NEXT บนหน้าจอ! -> ส่งข้อมูลไปยัง Webhook")
                    
                    -- ดึงค่าจากเกม
                    local username = player.Name
                    local level = player:FindFirstChild("level") and player.level.Value or "N/A"
                    local matchDMG = game:GetService("ReplicatedStorage"):FindFirstChild("MatchDMG") and game:GetService("ReplicatedStorage").MatchDMG.Value or 0
                    local wave = game:GetService("ReplicatedStorage"):FindFirstChild("Wave") and game:GetService("ReplicatedStorage").Wave.Value or 0
                    local result = "VICTORY" -- อาจต้องเปลี่ยนตามเกม
                    local rewards = game:GetService("ReplicatedStorage"):FindFirstChild("Rewards") and game:GetService("ReplicatedStorage").Rewards.Value or "None"

                    sendWebhookMessage(username, level, matchDMG, wave, result, rewards)
                    break
                end
            end
        end
    end
end

-- 🔄 ตรวจสอบ GUI ทุกๆ 2 วินาที
while wait(2) do
    checkNextText()
end
