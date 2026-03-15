-- MODERN GLOW MARSHMALLOW HUB
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local ButtonCorner = Instance.new("UICorner")
local StatusLabel = Instance.new("TextLabel")
local GlowEffect = Instance.new("ImageLabel")

-- Setup UI
ScreenGui.Name = "MarshmallowHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame Utama
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 10)

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 1.2

-- Judul
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "STEALTH COOKER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- Status
StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0, 110)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 12
StatusLabel.BackgroundTransparency = 1

-- Tombol Glow
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
ToggleBtn.Text = "START"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.BorderSizePixel = 0

ButtonCorner.Parent = ToggleBtn
ButtonCorner.CornerRadius = UDim.new(0, 6)

-- Logic Buka Tutup (Right Shift)
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- Auto Cook Logic
_G.AutoCook = false
function pressE()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude
            if dist < 8 then 
                task.wait(math.random(4, 9)/10) -- Delay aman
                fireproximityprompt(v)
                return true
            end
        end
    end
    return false
end

ToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    ToggleBtn.Text = _G.AutoCook and "STOP" or "START"
    ToggleBtn.BackgroundColor3 = _G.AutoCook and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 150)
end)

spawn(function()
    while true do
        task.wait(1)
        if _G.AutoCook then
            StatusLabel.Text = "Adding Water..."
            if pressE() then task.wait(10 + math.random(1, 2)) end
            if not _G.AutoCook then continue end
            
            StatusLabel.Text = "Mixing Sugar & Gelatin..."
            pressE() task.wait(math.random(15, 25)/10)
            pressE()
            
            for i = 45, 1, -1 do
                if not _G.AutoCook then break end
                StatusLabel.Text = "Cooking: "..i.."s"
                task.wait(1)
            end
            if not _G.AutoCook then continue end

            StatusLabel.Text = "Collecting Result..."
            pressE()
            task.wait(math.random(5, 8))
        end
    end
end)
