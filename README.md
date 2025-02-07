local WebhookURL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"
local http_request = http_request or request or syn.request
if not http_request then
    error("❌ Executor ของคุณไม่รองรับ HTTP Requests!")
end

local dataSent = false  -- ป้องกันการส่งซ้ำ

-- 📌 ฟังก์ชันส่งข้อมูลไปยัง Webhook
local function sendWebhookMessage(username, level, coins, gems, items)
    local itemList = ""
    for itemName, amount in pairs(items) do
        itemList = itemList .. "- " .. itemName .. ": " .. tostring(amount) .. "\n"
    end

    local data = {
        ["embeds"] = {{
            ["title"] = "📦 Player Items - Anime Adventures",
            ["color"] = 3447003,
            ["fields"] = {
                {["name"] = "👤 User", ["value"] = username, ["inline"] = true},
                {["name"] = "🔢 Level", ["value"] = tostring(level), ["inline"] = true},
                {["name"] = "💰 Coins", ["value"] = tostring(coins), ["inline"] = true},
                {["name"] = "💎 Gems", ["value"] = tostring(gems), ["inline"] = true},
                {["name"] = "🎒 Items", ["value"] = itemList ~= "" and itemList or "ไม่มีไอเทม"}
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
        print("✅ ส่งข้อมูลไปยัง Webhook สำเร็จ!")
        dataSent = true
    else
        warn("❌ ส่งข้อมูลไม่สำเร็จ: " .. tostring(response))
    end
end

-- 📌 ฟังก์ชันตรวจสอบข้อมูลของผู้เล่น
local function checkPlayerStats()
    local player = game.Players.LocalPlayer
    if not player then 
        print("❌ ไม่พบผู้เล่น")
        return 
    end
    if dataSent then return end  -- ถ้าส่งไปแล้วให้หยุด

    print("\n🔎 เริ่มตรวจสอบข้อมูลผู้เล่น...")

    -- 🔍 ตรวจสอบ leaderstats
    local coins = "0"
    local gems = "0"
    if player:FindFirstChild("leaderstats") then
        print("✅ พบ leaderstats")
        if player.leaderstats:FindFirstChild("Coins") then
            coins = player.leaderstats.Coins.Value
        else
            print("⚠️ ไม่พบ Coins ใน leaderstats")
        end
        if player.leaderstats:FindFirstChild("Gems") then
            gems = player.leaderstats.Gems.Value
        else
            print("⚠️ ไม่พบ Gems ใน leaderstats")
        end
    else
        print("❌ ไม่พบ leaderstats")
    end

    -- 🔍 ตรวจสอบ Level
    local level = "N/A"
    if player:FindFirstChild("Stats") and player.Stats:FindFirstChild("Level") then
        level = player.Stats.Level.Value
        print("✅ Level:", level)
    else
        print("⚠️ ไม่พบ Level")
    end

    -- 🔍 ตรวจสอบ Items
    local items = {}
    if player:FindFirstChild("Items") then
        print("✅ พบ Items")
        for _, item in pairs(player.Items:GetChildren()) do
            items[item.Name] = item.Value
            print("📦 ไอเทม:", item.Name, "จำนวน:", item.Value)
        end
    else
        print("⚠️ ไม่พบ Items")
    end

    -- 🔥 ส่งข้อมูลไปยัง Webhook
    sendWebhookMessage(player.Name, level, coins, gems, items)
end

-- ⏳ เช็คทุก ๆ 5 วินาที เมื่ออยู่ Lobby
while wait(5) do
    checkPlayerStats()
end
