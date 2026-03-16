-- AUTOMS BY FLUU
local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- CLEANUP UI
local uiName = "AutomsByFluuFinal"
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild(uiName) then game:GetService("CoreGui")[uiName]:Destroy() end
    if lp.PlayerGui:FindFirstChild(uiName) then lp.PlayerGui[uiName]:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = uiName
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local successUI, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not successUI then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

-- [[ UI DESIGN ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -190)
MainFrame.Size = UDim2.new(0, 230, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AUTOMS BY FLUU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextSize = 14

-- STATS PANEL
local StatsFrame = Instance.new("Frame", MainFrame)
StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
StatsFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
StatsFrame.Size = UDim2.new(0.9, 0, 0, 105)
Instance.new("UICorner", StatsFrame)

local function createStatLabel(name, pos, color)
    local lbl = Instance.new("TextLabel", StatsFrame)
    lbl.Size = UDim2.new(1, -10, 0, 18)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.Text = name .. " : 0"
    return lbl
end

local WaterCount = createStatLabel("Water", UDim2.new(0, 10, 0, 5))
local SugarCount = createStatLabel("Sugar", UDim2.new(0, 10, 0, 23))
local GelatinCount = createStatLabel("Gelatin", UDim2.new(0, 10, 0, 41))
local UnfinishedMS = createStatLabel("⏳ Ready to Cook", UDim2.new(0, 10, 0, 62), Color3.fromRGB(255, 165, 0))
local FinishedMS = createStatLabel("✅ Finished MS", UDim2.new(0, 10, 0, 80), Color3.fromRGB(0, 255, 150))

-- [[ FUNCTIONS ]]

local function pressE_Global()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local root = char.HumanoidRootPart
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local pPos = (v.Parent:IsA("Model") and v.Parent:GetModelCFrame().Position) or (v.Parent:IsA("BasePart") and v.Parent.Position)
            if pPos then
                if (root.Position - pPos).Magnitude < 15 then
                    fireproximityprompt(v)
                    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.05)
                    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    return true
                end
            end
        end
    end
    return false
end

local function interactPot()
    for i = 1, 3 do
        if pressE_Global() then return true end
        task.wait(0.4)
    end
    return false
end

local function safeEquip(n)
    local b = lp.Backpack
    local c = lp.Character
    if not b or not c then return false end
    local current = c:FindFirstChildWhichIsA("Tool")
    if current and string.find(current.Name:lower(), n:lower()) then return true end
    for _, t in pairs(b:GetChildren()) do
        if t:IsA("Tool") and string.find(t.Name:lower(), n:lower()) then
            c.Humanoid:EquipTool(t)
            task.wait(0.8)
            return true
        end
    end
    return false
end

-- [[ BUTTONS & LOGIC ]]
local QtyInput = Instance.new("TextBox", MainFrame)
QtyInput.Size = UDim2.new(0.85, 0, 0, 30); QtyInput.Position = UDim2.new(0.075, 0, 0.45, 0)
QtyInput.PlaceholderText = "Beli berapa?"; QtyInput.Text = "100"
QtyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35); QtyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", QtyInput)

local CookBtn = Instance.new("TextButton", MainFrame)
CookBtn.Size = UDim2.new(0.85, 0, 0, 40); CookBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
CookBtn.Text = "START COOKING"; CookBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CookBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CookBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CookBtn)

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 25); Status.Position = UDim2.new(0, 0, 0.88, 0)
Status.Text = "Status: Idle"; Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.BackgroundTransparency = 1; Status.Font = Enum.Font.Gotham; Status.TextSize = 11

-- STATS REFRESH (Ditambah pengecekan bahan)
local hasMaterials = false
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local w, s, g, fi = 0, 0, 0, 0
            local inv = lp.Backpack:GetChildren()
            if lp.Character then for _, v in pairs(lp.Character:GetChildren()) do if v:IsA("Tool") then table.insert(inv, v) end end end
            for _, item in pairs(inv) do
                local n = item.Name:lower()
                if n:find("water") then w = w + 1
                elseif n:find("sugar") and not n:find("empty") then s = s + 1
                elseif n:find("gelatin") then g = g + 1
                elseif n:find("marshmallow") or n:find("ms") then
                    if not n:find("unfinish") and not n:find("raw") then fi = fi + 1 end
                end
            end
            local combo = math.min(w, s, g)
            hasMaterials = (combo > 0)
            WaterCount.Text = "Water : "..w; SugarCount.Text = "Sugar : "..s; GelatinCount.Text = "Gelatin : "..g
            UnfinishedMS.Text = "⏳ Ready to Cook : "..combo; FinishedMS.Text = "✅ Finished MS : "..fi
        end)
    end
end)

_G.AutoCook = false
CookBtn.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    CookBtn.Text = _G.AutoCook and "STOP COOKING" or "START COOKING"
    CookBtn.BackgroundColor3 = _G.AutoCook and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoCook then
            if not hasMaterials then
                Status.Text = "Status: Out of Materials!"
                task.wait(2)
            else
                -- 1. WATER
                if safeEquip("Water") then
                    Status.Text = "Status: Water -> Pot"
                    task.wait(0.5)
                    interactPot()
                    for i=21,1,-1 do if not _G.AutoCook then break end Status.Text="Water CD ("..i.."s)" task.wait(1) end
                end
                -- 2. SUGAR
                if _G.AutoCook and safeEquip("Sugar") then
                    Status.Text = "Status: Sugar -> Pot"
                    task.wait(0.5)
                    interactPot()
                    task.wait(3)
                end
                -- 3. GELATIN
                if _G.AutoCook and safeEquip("Gelatin") then
                    Status.Text = "Status: Gelatin -> Pot"
                    task.wait(0.5)
                    interactPot()
                    task.wait(3)
                end
                -- 4. COOKING
                if _G.AutoCook then
                    for i=46,1,-1 do if not _G.AutoCook then break end Status.Text="Cooking ("..i.."s)" task.wait(1) end
                end
                -- 5. COLLECT
                if _G.AutoCook and safeEquip("Empty") then
                    Status.Text = "Status: Collecting..."
                    task.wait(0.5)
                    interactPot()
                    task.wait(5)
                end
            end
        end
    end
end)
