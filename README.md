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

-- ตรวจจับว่าด่านจบไปแล้วหรือไม่
local lastResult = nil  
local isProcessing = false -- ตัวแปรป้องกันการส่งซ้ำ

local function checkEndGameText()
    if isProcessing then return end -- ถ้ากำลังส่งอยู่ หยุดก่อน

    local player = game.Players.LocalPlayer
    if not player then return end

    local screenGui = player:FindFirstChild("PlayerGui") 
    if screenGui then
        for _, guiObject in pairs(screenGui:GetDescendants()) do
            if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") then
                local text = guiObject.Text:upper()
                if text == "VICTORY" or text == "DEFEAT" then
                    if lastResult ~= text then 
                        isProcessing = true -- ป้องกันการส่งซ้ำ
                        print("🔍 พบข้อความ " .. text .. " บนหน้าจอ! -> ส่งข้อมูลไปยัง Webhook")
                        
                        -- ดึงค่าจากเกม
                        local username = player.Name
                        local level = player:FindFirstChild("level") and player.level.Value or "N/A"
                        local matchDMG = game:GetService("ReplicatedStorage"):FindFirstChild("MatchDMG") and game:GetService("ReplicatedStorage").MatchDMG.Value or 0
                        local wave = game:GetService("ReplicatedStorage"):FindFirstChild("Wave") and game:GetService("ReplicatedStorage").Wave.Value or 0
                        local rewards = game:GetService("ReplicatedStorage"):FindFirstChild("Rewards") and game:GetService("ReplicatedStorage").Rewards.Value or "None"

                        sendWebhookMessage(username, level, matchDMG, wave, text, rewards)

                        lastResult = text  -- บันทึกผลล่าสุด
                        wait(10) -- Cooldown 10 วินาที
                        isProcessing = false -- ปลดล็อกให้ส่งได้ใหม่
                    else
                        print("⚠️ ข้อความเดิมถูกตรวจพบแล้ว ไม่ส่งซ้ำ")
                    end
                    break
                end
            end
        end
    end
end

-- 🔄 ตรวจสอบ GUI ทุกๆ 2 วินาที
while wait(2) do
    checkEndGameText()
end
