-- AUTOMS BY FLUU - SOUTH BRONX
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

-- Dashboard
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

-- LOGIKA PENCET E (KEMBALI KE VERSI AWAL YANG BISA)
function classicPressE()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local p = game.Players.LocalPlayer
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude
                if dist < 10 then -- Jarak standar yang berhasil di awal
                    fireproximityprompt(v)
                    return true
                end
            end
        end
    end
    return false
end

-- FUNGSI EQUIP ITEM
function autoEquip(name)
    local p = game.Players.LocalPlayer
    local bp = p:FindFirstChild("Backpack")
    local char = p.Character
    if not bp or not char then return false end
    
    local held = char:FindFirstChildOfClass("Tool")
    if held and string.find(string.lower(held.Name), string.lower(name)) then return true end
    
    for _, tool in pairs(bp:GetChildren()) do
        if string.find(string.lower(tool.Name), string.lower(name)) then
            char.Humanoid:EquipTool(tool)
            task.wait(0.5)
            return true
        end
    end
    return false
end

-- DASHBOARD UPDATE
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
        task.wait(1.5)
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

-- MAIN AFK LOOP (SESUAI REQUEST: AIR -> CD 20S -> SUGAR -> GELATIN -> MASAK 45S -> AMBIL)
spawn(function()
    while true do
        task.wait(1)
        if _G.AutoCook then
            -- 1. WATER -> CD 20S
            StatusLabel.Text = "Status: Mencari Water..."
            if autoEquip("Water") then
                task.wait(0.5)
                StatusLabel.Text = "Status: E - Masukkan Water..."
                if classicPressE() then
                    for i = 20, 1, -1 do
                        if not _G.AutoCook then break end
                        StatusLabel.Text = "Status: Water CD ("..i.."s)"
                        task.wait(1)
                    end
                end
            end

            if not _G.AutoCook then continue end

            -- 2. SUGAR
            StatusLabel.Text = "Status: Mencari Sugar..."
            if autoEquip("Sugar") then
                task.wait(0.5)
                StatusLabel.Text = "Status: E - Masukkan Sugar..."
                classicPressE()
                task.wait(2)
            end

            -- 3. GELATIN
            StatusLabel.Text = "Status: Mencari Gelatin..."
            if autoEquip("Gelatin") then
                task.wait(0.5)
                StatusLabel.Text = "Status: E - Masukkan Gelatin..."
                classicPressE()
                task.wait(2)
            end

            -- 4. MASAK CD 45S
            for i = 45, 1, -1 do
                if not _G.AutoCook then break end
                StatusLabel.Text = "Status: Memasak ("..i.."s)"
                task.wait(1)
            end

            -- 5. AMBIL (EMPTY BAG)
            StatusLabel.Text = "Status: Mencari Empty Bag..."
            if autoEquip("Empty") then
                task.wait(1)
                StatusLabel.Text = "Status: E - Ambil Hasil!"
                classicPressE()
                task.wait(3)
            end
        else
            StatusLabel.Text = "Status: Idle"
        end
    end
end)
