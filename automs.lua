-- AUTOMS BY FLUU - SOUTH BRONX (STRICT FLOW VERSION)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

-- Setup UI (Bisa Digeser)
ScreenGui.Name = "AutomsByFluu"
ScreenGui.Parent = game:GetService("CoreGui")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0, 50, 0.5, -125)
MainFrame.Size = UDim2.new(0, 220, 0, 260)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

-- Judul & Dashboard
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AUTOMS BY FLUU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

local StatsFrame = Instance.new("Frame", MainFrame)
StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
StatsFrame.Position = UDim2.new(0.05, 0, 0.18, 0)
StatsFrame.Size = UDim2.new(0.9, 0, 0, 110)
Instance.new("UICorner", StatsFrame)

local function createStatLabel(name, pos, color)
    local lbl = Instance.new("TextLabel", StatsFrame)
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

local WaterCount = createStatLabel("Water Stock", UDim2.new(0, 10, 0, 5))
local SugarCount = createStatLabel("Sugar Stock", UDim2.new(0, 10, 0, 25))
local GelatinCount = createStatLabel("Gelatin Stock", UDim2.new(0, 10, 0, 45))
local UnfinishedMS = createStatLabel("⏳ Unfinished MS", UDim2.new(0, 10, 0, 65), Color3.fromRGB(255, 165, 0))
local FinishedMS = createStatLabel("✅ Finished MS", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 255, 150))

-- FUNGSI PRESS E (MENCARI PROXIMITY TERDEKAT)
function pressE()
    local p = game.Players.LocalPlayer
    if not p.Character then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local dist = (p.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude
            if dist < 12 then
                fireproximityprompt(v)
                return true
            end
        end
    end
    return false
end

-- FUNGSI EQUIP ITEM (BERDASARKAN NAMA)
function equip(name)
    local p = game.Players.LocalPlayer
    local bp = p:FindFirstChild("Backpack")
    if not bp or not p.Character then return false end
    
    -- Cek kalau sudah dipegang
    local current = p.Character:FindFirstChildOfClass("Tool")
    if current and current.Name:lower():find(name:lower()) then return true end
    
    -- Cari di tas
    for _, tool in pairs(bp:GetChildren()) do
        if tool.Name:lower():find(name:lower()) then
            p.Character.Humanoid:EquipTool(tool)
            task.wait(0.5)
            return true
        end
    end
    return false
end

-- UPDATE DASHBOARD
spawn(function()
    while true do
        local p = game.Players.LocalPlayer
        if p and p:FindFirstChild("Backpack") then
            local items = p.Backpack:GetChildren()
            if p.Character then for _, v in pairs(p.Character:GetChildren()) do if v:IsA("Tool") then table.insert(items, v) end end end
            local w, s, g, un, fi = 0, 0, 0, 0, 0
            for _, item in pairs(items) do
                local n = item.Name:lower()
                if n:find("water") then w = w + 1
                elseif n:find("sugar") and not n:find("empty") then s = s + 1
                elseif n:find("gelatin") then g = g + 1
                elseif n:find("marshmallow") then
                    if n:find("unfinish") or n:find("raw") then un = un + 1 else fi = fi + 1 end
                end
            end
            WaterCount.Text = "Water Stock : "..w
            SugarCount.Text = "Sugar Stock : "..s
            GelatinCount.Text = "Gelatin Stock : "..g
            UnfinishedMS.Text = "⏳ Unfinished MS : "..un
            FinishedMS.Text = "✅ Finished MS : "..fi
        end
        task.wait(1)
    end
end)

_G.AutoCook = false
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Text = "START AFK"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
Instance.new("UICorner", ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    ToggleBtn.Text = _G.AutoCook and "STOP AFK" or "START AFK"
    ToggleBtn.BackgroundColor3 = _G.AutoCook and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 150)
end)

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0.85, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11

-- MAIN LOOP (URUTAN SESUAI PERMINTAAN)
spawn(function()
    while true do
        task.wait(1)
        if _G.AutoCook then
            -- 1. WATER & CD 20s
            StatusLabel.Text = "Status: Equip Water..."
            if equip("Water") then
                task.wait(0.5)
                StatusLabel.Text = "Status: E - Masukin Water..."
                if pressE() then
                    for i = 20, 1, -1 do
                        if not _G.AutoCook then break end
                        StatusLabel.Text = "Status: Water CD ("..i.."s)"
                        task.wait(1)
                    end
                end
            end

            if not _G.AutoCook then continue end

            -- 2. SUGAR
            StatusLabel.Text = "Status: Equip Sugar..."
            if equip("Sugar") then
                task.wait(0.5)
                StatusLabel.Text = "Status: E - Masukin Sugar..."
                pressE()
                task.wait(2) -- Jeda antar bahan
            end

            if not _G.AutoCook then continue end

            -- 3. GELATIN
            StatusLabel.Text = "Status: Equip Gelatin..."
            if equip("Gelatin") then
                task.wait(0.5)
                StatusLabel.Text = "Status: E - Masukin Gelatin..."
                pressE()
                task.wait(2)
            end

            -- 4. COOKING CD 45s
            for i = 45, 1, -1 do
                if not _G.AutoCook then break end
                StatusLabel.Text = "Status: Memasak ("..i.."s)"
                task.wait(1)
            end

            if not _G.AutoCook then continue end

            -- 5. AMBIL (Pegang Empty Bag dulu baru E)
            StatusLabel.Text = "Status: Equip Empty Bag..."
            if equip("Empty") then
                task.wait(1)
                StatusLabel.Text = "Status: E - Ambil Hasil!"
                pressE()
                task.wait(3)
            end
        else
            StatusLabel.Text = "Status: Idle"
        end
    end
end)
