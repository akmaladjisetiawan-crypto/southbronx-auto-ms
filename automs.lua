-- AUTOMS BY FLUU - SOUTH BRONX
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
ScreenGui.Name = "AutomsByFluu"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -125)
MainFrame.Size = UDim2.new(0, 230, 0, 250)
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
Title.Text = "AUTOMS BY FLUU"
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
    lbl.Text = name .. " : 0"
    return lbl
end

WaterCount = createStatLabel("Water Stock", UDim2.new(0, 10, 0, 5))
SugarCount = createStatLabel("Sugar Stock", UDim2.new(0, 10, 0, 25))
GelatinCount = createStatLabel("Gelatin Stock", UDim2.new(0, 10, 0, 45))
UnfinishedMS = createStatLabel("⏳ Unfinished MS", UDim2.new(0, 10, 0, 65), Color3.fromRGB(255, 165, 0))
FinishedMS = createStatLabel("✅ Finished MS", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 255, 150))

-- LOGIK: Update Dashboard
local function updateDashboard()
    local p = game.Players.LocalPlayer
    if not p or not p:FindFirstChild("Backpack") then return end
    
    local allItems = {}
    for _, v in pairs(p.Backpack:GetChildren()) do table.insert(allItems, v.Name) end
    if p.Character then
        for _, v in pairs(p.Character:GetChildren()) do
            if v:IsA("Tool") then table.insert(allItems, v.Name) end
        end
    end

    local w, s, g, un, fi = 0, 0, 0, 0, 0
    for _, name in pairs(allItems) do
        local n = name:lower()
        if n:find("water") then w = w + 1
        elseif n:find("sugar") then s = s + 1
        elseif n:find("gelatin") then g = g + 1
        elseif n:find("marshmallow") then
            if n:find("unfinish") or n:find("process") or n:find("not") or n:find("raw") or n:find("cook") then
                un = un + 1
            else
                fi = fi + 1
            end
        end
    end
    
    WaterCount.Text = "Water Stock : " .. w
    SugarCount.Text = "Sugar Stock : " .. s
    GelatinCount.Text = "Gelatin Stock : " .. g
    UnfinishedMS.Text = "⏳ Unfinished MS : " .. un
    FinishedMS.Text = "✅ Finished MS : " .. fi
end

spawn(function()
    while true do
        updateDashboard()
        task.wait(1.5)
    end
end)

-- Fungsi Pegang Tas Kosong
local function equipEmptyBag()
    local p = game.Players.LocalPlayer
    local bag = p.Backpack:FindFirstChild("Empty Bag") or p.Backpack:FindFirstChild("Bag")
    
    -- Jika tidak ketemu nama "Empty Bag", cari yang namanya ada kata "Bag"
    if not bag then
        for _, v in pairs(p.Backpack:GetChildren()) do
            if v.Name:lower():find("bag") and v.Name:lower():find("empty") then
                bag = v
                break
            end
        end
    end
    
    if bag then
        p.Character.Humanoid:EquipTool(bag)
        return true
    end
    return false
end

_G.AutoCook = false
function pressE()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - v.Parent.Position).Magnitude
                if dist < 8 then 
                    fireproximityprompt(v)
                    return true
                end
            end
        end
    end
    return false
end

-- Button Setup
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Text = "START AFK"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ButtonCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    ToggleBtn.Text = _G.AutoCook and "STOP AFK" or "START AFK"
    ToggleBtn.BackgroundColor3 = _G.AutoCook and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 150)
end)

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0.9, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Text = "System: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11

-- MAIN LOOP
spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoCook then
            -- 1. Masukkan Air
            StatusLabel.Text = "System: Adding Water..."
            if pressE() then 
                for i = 10, 1, -1 do
                    if not _G.AutoCook then break end
                    StatusLabel.Text = "System: Water CD ("..i.."s)"
                    task.wait(1)
                end
            end
            
            if not _G.AutoCook then continue end
            
            -- 2. Mixing Bahan
            StatusLabel.Text = "System: Mixing..."
            pressE() task.wait(1)
            pressE()
            
            -- 3. Proses Masak
            for i = 46, 1, -1 do
                if not _G.AutoCook then break end
                StatusLabel.Text = "System: Cooking ("..i.."s)"
                task.wait(1)
            end
            
            if not _G.AutoCook then continue end

            -- 4. AUTO-EQUIP BAG & COLLECT
            StatusLabel.Text = "System: Equipping Bag..."
            equipEmptyBag() -- Pegang tasnya dulu
            task.wait(0.5)
            StatusLabel.Text = "System: Collecting MS..."
            pressE()
            task.wait(0.5)
        else
            StatusLabel.Text = "System: Idle"
        end
    end
end)
