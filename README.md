-- สร้าง GUI
local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local frame = Instance.new("Frame", screenGui)
local startButton = Instance.new("TextButton", screenGui)
local stopButton = Instance.new("TextButton", screenGui)

-- ตั้งค่ากรอบสี่เหลี่ยมสีดำ
frame.Size = UDim2.new(0, 550, 0, 550) -- ขนาด 550x550 พิกเซล
frame.Position = UDim2.new(0.5, -275, 0.5, -275) -- จัดตำแหน่งตรงกลาง
frame.BackgroundColor3 = Color3.new(0, 0, 0) -- สีดำ
frame.BorderSizePixel = 0

-- ตั้งค่าปุ่ม Start
startButton.Size = UDim2.new(0, 100, 0, 50)
startButton.Position = UDim2.new(0, 10, 0, 10)
startButton.Text = "Start"
startButton.BackgroundColor3 = Color3.new(0, 1, 0) -- สีเขียว

-- ตั้งค่าปุ่ม Stop
stopButton.Size = UDim2.new(0, 100, 0, 50)
stopButton.Position = UDim2.new(0, 120, 0, 10)
stopButton.Text = "Stop"
stopButton.BackgroundColor3 = Color3.new(1, 0, 0) -- สีแดง

-- ตัวแปรควบคุมการทำงาน
local running = false

-- ฟังก์ชันตรวจจับและคลิกวัตถุ
local function clickObjects()
    while running do
        -- ตรวจสอบวัตถุทั้งหมดใน Workspace
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                -- แปลงตำแหน่งวัตถุในโลกเกมเป็นตำแหน่งบนหน้าจอ
                local screenPosition, onScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(obj.Position)
                if onScreen then
                    -- ตรวจสอบว่าวัตถุอยู่ในกรอบสีดำหรือไม่
                    if screenPosition.X >= frame.AbsolutePosition.X and screenPosition.X <= frame.AbsolutePosition.X + frame.AbsoluteSize.X and screenPosition.Y >= frame.AbsolutePosition.Y and screenPosition.Y <= frame.AbsolutePosition.Y + frame.AbsoluteSize.Y then
                        -- คลิกหรือทำการกระทำกับวัตถุ
                        obj:Destroy() -- หรือทำการกระทำอื่นๆ ตามต้องการ
                    end
                end
            end
        end
        wait(0.1) -- รอ 0.1 วินาทีก่อนตรวจสอบอีกครั้ง
    end
end

-- ปุ่ม Start
startButton.MouseButton1Click:Connect(function()
    running = true
    clickObjects()
end)

-- ปุ่ม Stop
stopButton.MouseButton1Click:Connect(function()
    running = false
end)
