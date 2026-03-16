-- AUTOMS BY FLUU - SOUTH BRONX
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local ButtonCorner = Instance.new("UICorner")
local StatusLabel = Instance.new("TextLabel")

-- Setup UI
ScreenGui.Name = "AutomsByFluu"
ScreenGui.Parent = game:GetService("CoreGui")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -125)
MainFrame.Size = UDim2.new(0, 230, 0, 180) -- Lebih compact
MainFrame.Active = true
MainFrame.Draggable = true
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 1.5

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AUTOMS BY FLUU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 45)
ToggleBtn.Text = "START AFK"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleBtn

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Text = "System: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12

-- GLOBAL TOGGLE
_G.AutoCook = false

-- FUNGSI PRESS E YANG LEBIH KUAT
function forcePressE()
    local success = false
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local p = game.Players.LocalPlayer
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude
                if dist < 12 then -- Jarak agak jauh dikit biar aman
                    fireproximityprompt(v)
                    success = true
                end
            end
        end
    end
    return success
end

-- FUNGSI CARI ITEM (SEARCH BY PARTIAL NAME)
function equipItem(name)
    local p = game.Players.LocalPlayer
    local backpack = p:FindFirstChild("Backpack")
    local char = p.Character
    if not backpack or not char then return false end

    -- Cari di hotbar/tangan dulu
    local held = char:FindFirstChildOfClass("Tool")
    if held and string.find(string.lower(held.Name), string.lower(name)) then
        return true
    end

    -- Cari di tas
    for _, tool in pairs(backpack:GetChildren()) do
        if string.find(string.lower(tool.Name), string.lower(name)) then
            char.Humanoid:EquipTool(tool)
            task.wait(0.5) -- Jeda biar animasi pegang kelar
            return true
        end
    end
    return false
end

ToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    ToggleBtn.Text = _G.AutoCook and "STOP AFK" or "START AFK"
    ToggleBtn.BackgroundColor3 = _G.AutoCook and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 150)
end)

-- MAIN LOOP
spawn(function()
    while true do
        task.wait(1)
        if _G.AutoCook then
            -- STEP 1: AIR
            StatusLabel.Text = "Status: Mencari Air..."
            if equipItem("Water") then
                task.wait(0.5)
                if forcePressE() then
                    for i = 20, 1, -1 do
                        if not _G.AutoCook then break end
                        StatusLabel.Text = "Status: Water CD ("..i.."s)"
                        task.wait(1)
                    end
                end
            else
                StatusLabel.Text = "Status: Air Tidak Ketemu!"
                task.wait(2)
            end

            if not _G.AutoCook then continue end

            -- STEP 2: GULA
            StatusLabel.Text = "Status: Mencari Sugar..."
            if equipItem("Sugar") then
                task.wait(0.8)
                forcePressE()
                task.wait(1.5)
            end

            -- STEP 3: GELATIN
            StatusLabel.Text = "Status: Mencari Gelatin..."
            if equipItem("Gelatin") then
                task.wait(0.8)
                forcePressE()
                task.wait(1.5)
            end

            -- STEP 4: MASAK
            for i = 46, 1, -1 do
                if not _G.AutoCook then break end
                StatusLabel.Text = "Status: Memasak ("..i.."s)"
                task.wait(1)
            end

            if not _G.AutoCook then continue end

            -- STEP 5: AMBIL (EMPTY BAG)
            StatusLabel.Text = "Status: Mencari Empty Bag..."
            if equipItem("Empty") then
                task.wait(1)
                StatusLabel.Text = "Status: Mengambil Hasil!"
                forcePressE()
                task.wait(2)
            end
        else
            StatusLabel.Text = "Status: Idle"
        end
    end
end)
