local WebhookURL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"

-- ตรวจสอบว่ามีฟังก์ชัน HTTP ที่รองรับ
local http_request = http_request or request or syn.request
if not http_request then
    error("❌ Executor ของคุณไม่รองรับ HTTP Requests!")
end

-- ฟังก์ชันสำหรับส่ง Webhook
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

    -- ส่ง HTTP Request
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

-- 🛠 ฟังก์ชันทดสอบ (Test Function)
function testWebhook()
    print("🔍 กำลังทดสอบการส่ง Webhook...")
    sendWebhookMessage("TestPlayer", 999, 99.99, 20, "VICTORY", "+999 Gems, +999 Tokens")
end

-- เรียกใช้ฟังก์ชันทดสอบ
testWebhook()
