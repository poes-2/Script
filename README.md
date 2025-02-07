local WebhookURL = "https://discord.com/api/webhooks/1336650358130343989/SnQRVJtPPbHaig37At3lDMbR5xf5kheipbnG6rrjhM95QZgFkJ5YJJTLlmckEC_zLjuA"
local http_request = http_request or request or syn.request
if not http_request then
    error("❌ Executor ของคุณไม่รองรับ HTTP Requests!")
end

-- ตัวแปรเช็คว่าเคยส่งข้อมูลไปแล้วหรือยัง
local dataSent = false

-- 📌 ฟังก์ชันส่งข้อมูลไปยัง Webhook
local function sendWebhookMessage(username, level, coins, gems, items)
    local inventoryList = ""
    for itemName, amount in pairs(items) do
        inventoryList = inventoryList .. "- " .. itemName .. ": " .. tostring(amount) .. "\n"
    end

    local data = {
        ["embeds"] = {{
            ["title"] = "📦 Player Inventory - Anime Adventures",
            ["color"] = 3447003,
            ["fields"] = {
                {["name"] = "👤 User", ["value"] = username, ["inline"] = true},
                {["name"] = "🔢 Level", ["value"] = tostring(level), ["inline"] = true},
                {["name"] = "💰 Coins", ["value"] = tostring(coins), ["inline"] = true},
                {["name"] = "💎 Gems", ["value"] = tostring(gems), ["inline"] = true},
                {["name"] = "🎒 Inventory", ["value"] = inventoryList}
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
        dataSent = true -- ป้องกันการส่งซ้ำ
    else
        warn("❌ ส่งข้อมูลไม่สำเร็จ: " .. tostring(response))
    end
end

-- 📌 ฟังก์ชันดึงข้อมูลจาก Lobby
local function checkPlayerStats()
    local player = game.Players.LocalPlayer
    if not player then return end
    if dataSent then return end  -- ถ้าเคยส่งไปแล้วให้หยุด

    -- 🔎 ดึงข้อมูล
    local level = player:FindFirstChild("Level") and player.Level.Value or "N/A"
    local coins = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Coins") and player.leaderstats.Coins.Value or "0"
    local gems = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Gems") and player.leaderstats.Gems.Value or "0"

    -- 🔎 ตรวจสอบของในกระเป๋า
    local inventory = {}
    if player:FindFirstChild("Inventory") then
        for _, item in pairs(player.Inventory:GetChildren()) do
            inventory[item.Name] = item.Value
        end
    end

    -- 🔥 ส่งข้อมูลไปยัง Webhook
    sendWebhookMessage(player.Name, level, coins, gems, inventory)
end

-- ⏳ เช็คทุก ๆ 5 วินาที เมื่ออยู่ Lobby
while wait(5) do
    checkPlayerStats()
end
