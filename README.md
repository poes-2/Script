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

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == game.Players.LocalPlayer then
        -- ค้นหา leaderstats ที่อยู่ใน Player
        local stats = player:FindFirstChild("leaderstats")
        
        -- ดึงค่าต่างๆ จาก leaderstats
        local username = player.Name
        local level = stats and stats:FindFirstChild("Level") and stats.Level.Value or "N/A"
        local matchDMG = stats and stats:FindFirstChild("MatchDMG") and stats.MatchDMG.Value or 0
        local wave = stats and stats:FindFirstChild("Wave") and stats.Wave.Value or 0
        local result = stats and stats:FindFirstChild("Result") and stats.Result.Value or "UNKNOWN"
        local rewards = stats and stats:FindFirstChild("Rewards") and stats.Rewards.Value or "None"

        -- ส่งข้อมูลไปยัง Webhook
        sendWebhookMessage(username, level, matchDMG, wave, result, rewards)
    end
end)
