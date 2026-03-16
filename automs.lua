-- MODERN GLOW SOUTH BRONX (PRODUCTION DASHBOARD)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local ButtonCorner = Instance.new("UICorner")
local StatusLabel = Instance.new("TextLabel")

-- Dashboard Labels
local WaterCount, SugarCount, GelatinCount, UnfinishedMS, FinishedMS

-- Setup UI Utama
ScreenGui.Name = "MarshmallowHubV3"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -125)
MainFrame.Size = UDim2.new(0, 230, 0, 250) -- Ukuran pas buat dashboard
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 1.5

-- Judul
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "MARSHMALLOW FACTORY"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- Container Stats
local StatsFrame = Instance.new("Frame")
StatsFrame.Parent = MainFrame
StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
StatsFrame.Position = UDim2.new(0.05, 0, 0.18, 0)
StatsFrame.Size = UDim2.new(0.9, 0, 0, 110)
local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 8)
StatsCorner.Parent = StatsFrame

local function createStatLabel(name, pos, color)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = StatsFrame
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.Text = name .. ": 0"
    return lbl
end

-- Membuat Label Dashboard
WaterCount = createStatLabel("💧 Water", UDim2.new(0, 10, 0, 5))
SugarCount = createStatLabel("⬜ Sugar", UDim2.new(0, 10, 0, 25))
GelatinCount = createStatLabel("🧬 Gelatin", UDim2.new(0, 10, 0, 45))
UnfinishedMS = createStatLabel("⏳ Unfinished MS", UDim2.new(0, 10, 0, 65), Color3.fromRGB(255, 165, 0))
FinishedMS = createStatLabel("✅ Finished MS", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 255, 150))

-- Status Kerja
StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0.9, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Text = "System: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11

-- Button
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Text = "START AFK"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ButtonCorner.Parent = ToggleBtn

-- LOGIK: Scan Inventory
local function updateDashboard()
    local backpack = game.Players.LocalPlayer.Backpack:GetChildren()
    local char = game.Players.LocalPlayer.Character:GetChildren()
    local allItems = {}
    
    for _, v in pairs(backpack) do table.insert(allItems, v.Name) end
    for _, v in pairs(char) do table.insert(allItems, v.Name) end

    local w, s, g, un, fi = 0, 0, 0, 0, 0
    for _, name in pairs(allItems) do
        local n = name:lower()
        if n:find("water") then w = w + 1
        elseif n:find("sugar") then s = s + 1
        elseif n:find("gelatin") then g = g + 1
        elseif n:find("marshmallow") then
            if n:find("unfinish") or n:find("process") or n:find("not ready") then
                un = un + 1
            else
                fi = fi + 1
            end
        end
    end
    
    WaterCount.Text = "💧 Water: " .. w
    SugarCount.Text = "⬜ Sugar: " .. s
    GelatinCount.Text = "🧬 Gelatin: " .. g
    UnfinishedMS.Text = "⏳ Unfinished MS: " .. un
    FinishedMS.Text = "✅ Finished MS: " .. fi
end

spawn(function()
    while true do
        updateDashboard()
        task.wait(2)
    end
end)

-- LOGIK: AFK & Anti-AFK
_G.AutoCook = false
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

function pressE()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude
            if dist < 8 then 
                task.wait(math.random(4, 8)/10)
                fireproximityprompt(v)
                return true
            end
        end
    end
    return false
end

ToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    ToggleBtn.Text = _G.AutoCook and "STOP AFK" or "START AFK"
    ToggleBtn.BackgroundColor3 = _G.AutoCook and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 150)
end)

-- RShift Toggle
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Main Production Loop
spawn(function()
    while true do
        task.wait(1)
        if _G.AutoCook then
            StatusLabel.Text = "System: Adding Water..."
            if pressE() then task.wait(10) end
            if not _G.AutoCook then continue end
            
            StatusLabel.Text = "System: Mixing Ingredients..."
            pressE() task.wait(2.5)
            pressE()
            
            for i = 45, 1, -1 do
                if not _G.AutoCook then break end
                StatusLabel.Text = "System: Cooking ("..i.."s)"
                task.wait(1)
            end
            if not _G.AutoCook then continue end

            StatusLabel.Text = "System: Collecting MS..."
            pressE()
            task.wait(5)
        else
            StatusLabel.Text = "System: Idle"
        end
    end
end)
