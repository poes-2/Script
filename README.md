-- ประกาศตัวแปร
local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local frame = Instance.new("Frame", screenGui)
local startButton = Instance.new("TextButton", screenGui)
local stopButton = Instance.new("TextButton", screenGui)
local running = false

-- ตั้งค่ากรอบสี่เหลี่ยมสีแดง
frame.Size = UDim2.new(0, 550, 0, 550) -- ขนาด 550x550 พิกเซล
frame.Position = UDim2.new(0.5, -275, 0.5, -275) -- จัดตำแหน่งตรงกลาง
frame.BackgroundColor3 = Color3.new(1, 0, 0) -- สีแดง
frame.BorderSizePixel = 0

-- ตั้งค่าปุ่มเริ่มต้น
startButton.Size = UDim2.new(0, 100, 0, 50)
startButton.Position = UDim2.new(0, 10, 0, 10)
startButton.Text = "Start"
startButton.BackgroundColor3 = Color3.new(0, 1, 0) -- สีเขียว

-- ตั้งค่าปุ่มหยุด
stopButton.Size = UDim2.new(0, 100, 0, 50)
stopButton.Position = UDim2.new(0, 120, 0, 10)
stopButton.Text = "Stop"
stopButton.BackgroundColor3 = Color3.new(1, 0, 0) -- สีแดง

-- ฟังก์ชันตรวจจับและคลิก
local function clickObjects()
    while running do
        -- ตรวจสอบวัตถุที่อยู่ในกรอบ
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Position.X >= frame.AbsolutePosition.X and obj.Position.X <= frame.AbsolutePosition.X + frame.AbsoluteSize.X and obj.Position.Y >= frame.AbsolutePosition.Y and obj.Position.Y <= frame.AbsolutePosition.Y + frame.AbsoluteSize.Y then
                -- คลิกวัตถุ
                obj:Destroy() -- หรือทำการกระทำอื่นๆ ตามต้องการ
            end
        end
        wait(0.1) -- รอ 0.1 วินาทีก่อนตรวจสอบอีกครั้ง
    end
end

-- ปุ่มเริ่มต้น
startButton.MouseButton1Click:Connect(function()
    running = true
    clickObjects()
end)

-- ปุ่มหยุด
stopButton.MouseButton1Click:Connect(function()
    running = false
end)
