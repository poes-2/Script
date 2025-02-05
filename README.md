local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Webhook_URL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA" -- ใส่ Webhook ของคุณ

-- โหลด UI Library ที่ใช้งานกับ Codex ได้
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/6rN5yFXS"))() -- เปลี่ยนเป็น UI Library ที่คุณต้องการ

local Window = Library:CreateWindow("Anime Adventure Webhook")
local MainTab = Window:CreateTab("Main")

local startTime = os.time()

-- ฟังก์ชันส่ง Webhook
function sendDiscordMessage()
    local endTime = os.time()
    local elapsedTime = endTime - startTime
    local playerInfo = {
        username = LocalPlayer.Name,
        userId = LocalPlayer.UserId,
        avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
    }

    local stats = {
        damage = "N/A",
        kills = "N/A",
        waves = "N/A"
    }

    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") then
            if string.find(v.Text, "Damage:") then
                stats.damage = v.Text:gsub("Damage: ", "")
            elseif string.find(v.Text, "Kills:") then
                stats.kills = v.Text:gsub("Kills: ", "")
            elseif string.find(v.Text, "Wave:") then
                stats.waves = v.Text:gsub("Wave: ", "")
            end
        end
    end

    local data = {
        ["username"] = "Anime Adventures Bot",
        ["avatar_url"] = playerInfo.avatarUrl,
        ["embeds"] = {{
            ["title"] = "✅ **Mission Complete!** 🎉",
            ["color"] = 65280,
            ["thumbnail"] = {["url"] = playerInfo.avatarUrl},
            ["fields"] = {
                {["name"] = "👤 ผู้เล่น", ["value"] = playerInfo.username .. " (ID: " .. playerInfo.userId .. ")", ["inline"] = false},
                {["name"] = "🕒 ใช้เวลา", ["value"] = elapsedTime .. " วินาที", ["inline"] = true},
                {["name"] = "⚔️ Damage", ["value"] = stats.damage, ["inline"] = true},
                {["name"] = "💀 Kills", ["value"] = stats.kills, ["inline"] = true},
                {["name"] = "🌊 จำนวน Wave", ["value"] = stats.waves, ["inline"] = true}
            }
        }}
    }

    local jsonData = HttpService:JSONEncode(data)
    HttpService:PostAsync(Webhook_URL, jsonData, Enum.HttpContentType.ApplicationJson)
end

-- UI ปุ่มกด
MainTab:CreateButton("📩 ส่ง Webhook", function()
    sendDiscordMessage()
end)

-- ตรวจจับการชนะด่าน
spawn(function()
    while wait(1) do
        for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and string.find(v.Text, "Victory") then
                sendDiscordMessage()
                print("✅ ส่งข้อมูลไปยัง Discord แล้ว!")
                return
            end
        end
    end
end)

print("✅ สคริปต์พร้อมใช้งาน!")
