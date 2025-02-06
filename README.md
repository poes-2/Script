local HttpService = game:GetService("HttpService")
local WebhookURL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"

local data = {
    ["embeds"] = {{
        ["title"] = "Anime Adventures - Match Result",
        ["color"] = 5814783,
        ["fields"] = {
            {["name"] = "👤 User", ["value"] = "Player123", ["inline"] = true},
            {["name"] = "🔢 Level", ["value"] = "147", ["inline"] = true},
            {["name"] = "🗡️ Match DMG", ["value"] = "79.08M", ["inline"] = true},
            {["name"] = "⏳ Wave", ["value"] = "15", ["inline"] = true},
            {["name"] = "🏆 Result", ["value"] = "**VICTORY**", ["inline"] = true},
            {["name"] = "🎁 Rewards", ["value"] = "+24 Assassin Token, +8 Christmas Present, +75 Gems"}
        }
    }}
}

-- แปลงข้อมูลเป็น JSON และส่งไปที่ Webhook
local jsonData = HttpService:JSONEncode(data)
HttpService:PostAsync(WebhookURL, jsonData, Enum.HttpContentType.ApplicationJson)
