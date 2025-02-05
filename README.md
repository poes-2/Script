end HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Webhook_URL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA" -- ใส่ Webhook ของคุณ

local startTime = os.time()

-- ฟังก์ชันส่ง Webhook
function sendDiscordMessage(message)
    local endTime = os.time()
    local elapsedTime = endTime - startTime
    local playerInfo = {
        username = LocalPlayer.Name,
        userId = LocalPlayer.UserId,
    }
    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. playerInfo.userId .. "&width=420&height=420&format=png"
    
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
        ["avatar_url"] = avatarUrl,
        ["embeds"] = {{
            ["title"] = message,
            ["color"] = 65280,
            ["thumbnail"] = { ["url"] = avatarUrl },
            ["fields"] = {
                { ["name"] = "👤 ผู้เล่น", ["value"] = playerInfo.username .. " (ID: " .. playerInfo.userId .. ")", ["inline"] = false },
                { ["name"] = "🕒 ใช้เวลา", ["value"] = elapsedTime .. " วินาที", ["inline"] = true },
                { ["name"] = "⚔️ Damage", ["value"] = stats.damage, ["inline"] = true },
                { ["name"] = "💀 Kills", ["value"] = stats.kills, ["inline"] = true },
                { ["name"] = "🌊 จำนวน Wave", ["value"] = stats.waves, ["inline"] = true }
            }
        }}
    }

    local jsonData = HttpService:JSONEncode(data)
    local success, response = pcall(function()
        return HttpService:PostAsync(Webhook_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)
    
    if success then
        print("✅ ส่งข้อมูลสำเร็จ!")
    else
        print("❌ ส่งไม่สำเร็จ: ", response)
    end
end

-- ตรวจจับการชนะด่าน
spawn(function()
    while wait(1) do
        for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("GuiObject") then -- ตรวจจับ UI ทุกประเภท
                local text = v.Text or v:GetAttribute("Text") -- ดึงค่าข้อความจาก Attribute ด้วย
                if text then
                    print("🔍 พบข้อความใน UI: " .. text)
                    if string.find(text, "Victory") or string.find(text, "Mission Complete") then
                        print("🎉 ตรวจพบข้อความชนะด่าน! กำลังส่ง Webhook...")
                        sendDiscordMessage("🏆 **Mission Complete!** 🎉")
                        return
                    end
                end
            end
        end
    end
end)
print("✅ สคริปต์พร้อมใช้งาน! UI ควรจะแสดงแล้ว")
