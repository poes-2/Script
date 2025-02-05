local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Webhook_URL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA" -- แทนที่ด้วย Webhook ของคุณ

local startTime = os.time() -- เริ่มจับเวลา

local function getCharacterInfo()
    local characters = {}
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("Model") then
            local level = "??" -- ค่าเริ่มต้นหากหาเลเวลไม่เจอ
            for _, stat in pairs(v:GetChildren()) do
                if stat:IsA("IntValue") and stat.Name == "Level" then
                    level = stat.Value
                end
            end
            table.insert(characters, "- " .. v.Name .. " (Lv " .. level .. ")")
        end
    end
    return #characters > 0 and table.concat(characters, "\n") or "ไม่พบข้อมูล"
end

local function getRewards()
    local rewards = {}
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") and string.find(v.Text, "Reward:") then
            table.insert(rewards, v.Text)
        end
    end
    return #rewards > 0 and table.concat(rewards, "\n") or "ไม่มีของรางวัล"
end

local function getMapName()
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") and string.find(v.Text, "Map:") then
            return v.Text:gsub("Map: ", "")
        end
    end
    return "Unknown"
end

local function getPlayerStats()
    local stats = {
        damage = "ไม่พบข้อมูล",
        kills = "ไม่พบข้อมูล",
        waves = "ไม่พบข้อมูล"
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
    
    return stats
end

local function getPlayerInfo()
    return {
        username = LocalPlayer.Name, -- ชื่อผู้เล่น Roblox
        userId = LocalPlayer.UserId, -- ID ผู้เล่น
        avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
    }
end

local function sendDiscordMessage()
    local endTime = os.time()
    local elapsedTime = endTime - startTime -- คำนวณเวลาที่ใช้
    local playerInfo = getPlayerInfo()
    local stats = getPlayerStats()

    local data = {
        ["username"] = "Anime Adventures Bot",
        ["avatar_url"] = playerInfo.avatarUrl, -- ใช้รูปอวาตาร์ของผู้เล่น
        ["embeds"] = {{
            ["title"] = "✅ **Mission Complete!** 🎉",
            ["color"] = 65280, -- สีเขียว
            ["thumbnail"] = {["url"] = playerInfo.avatarUrl}, -- แสดงรูปอวาตาร์
            ["fields"] = {
                {["name"] = "👤 ผู้เล่น", ["value"] = playerInfo.username .. " (ID: " .. playerInfo.userId .. ")", ["inline"] = false},
                {["name"] = "📍 ด่านที่เล่น", ["value"] = getMapName(), ["inline"] = true},
                {["name"] = "🕒 ใช้เวลา", ["value"] = elapsedTime .. " วินาที", ["inline"] = true},
                {["name"] = "🎭 ตัวละครที่ใช้", ["value"] = getCharacterInfo(), ["inline"] = false},
                {["name"] = "⚔️ Damage", ["value"] = stats.damage, ["inline"] = true},
                {["name"] = "💀 Kills", ["value"] = stats.kills, ["inline"] = true},
                {["name"] = "🌊 จำนวน Wave", ["value"] = stats.waves, ["inline"] = true},
                {["name"] = "🎁 ของที่ได้รับ", ["value"] = getRewards(), ["inline"] = false}
            }
        }}
    }

    local jsonData = HttpService:JSONEncode(data)
    HttpService:PostAsync(Webhook_URL, jsonData, Enum.HttpContentType.ApplicationJson)
end

local function detectMissionComplete()
    while wait(1) do
        for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and string.find(v.Text, "Victory") then
                sendDiscordMessage()
                print("✅ ส่งข้อมูลไปยัง Discord แล้ว!")
                return
            end
        end
    end
end

print("กำลังรอตรวจจับการจบของด่าน...")
detectMissionComplete()
