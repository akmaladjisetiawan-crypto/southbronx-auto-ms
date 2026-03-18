-- [[ AUTOMS BY FLUU - UI FIX & AUTO BUY ]]
repeat task.wait() until game:IsLoaded()

local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local CG = game:GetService("CoreGui")

-- 1. CLEANUP & INITIALIZATION (DIPERKUAT)
local uiName = "AutomsByFluuFinal"
for _, v in pairs(CG:GetChildren()) do
    if v.Name == uiName then v:Destroy() end
end
for _, v in pairs(lp.PlayerGui:GetChildren()) do
    if v.Name == uiName then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = uiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Pastikan UI masuk ke CoreGui (biar gak hilang pas mati)
local successUI, _ = pcall(function() ScreenGui.Parent = CG end)
if not successUI then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

-- 2. UI DESIGN (TETAP SAMA)
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

-- 3. CORE FUNCTIONS (UTILITY)
local function clickText(txt)
    local pGui = lp:WaitForChild("PlayerGui")
    for _, v in pairs(pGui:GetDescendants()) do
        if (v:IsA("TextButton") or v:IsA("TextLabel")) and v.Visible then
            if string.find(string.lower(v.Text), string.lower(txt)) then
                local target = v
                if not v:IsA("TextButton") then
                    target = v:FindFirstAncestorWhichIsA("TextButton") or v.Parent
                end
                if target then
                    local pos = target.AbsolutePosition
                    local size = target.AbsoluteSize
                    VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2 + 58, 0, true, game, 1)
                    task.wait(0.1)
                    VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2 + 58, 0, false, game, 1)
                    return true
                end
            end
        end
    end
    return false
end

local function pressE_Global()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local root = char.HumanoidRootPart
    local closestPrompt = nil
    local shortestDist = 18 

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local pPos = (v.Parent:IsA("BasePart") and v.Parent.Position) or (v.Parent:IsA("Model") and v.Parent:GetModelCFrame().Position)
            if pPos then
                local dist = (root.Position - pPos).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closestPrompt = v
                end
            end
        end
    end

    if closestPrompt then
        fireproximityprompt(closestPrompt)
        VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        return true
    end
    return false
end

local function safeEquip(itemName)
    local b = lp.Backpack
    local c = lp.Character
    if not b or not c then return false end
    local current = c:FindFirstChildWhichIsA("Tool")
    if current and string.find(current.Name:lower(), itemName:lower()) then return true end
    for _, t in pairs(b:GetChildren()) do
        if t:IsA("Tool") and string.find(t.Name:lower(), itemName:lower()) then
            c.Humanoid:EquipTool(t)
            task.wait(0.6)
            return true
        end
    end
    return false
end

-- 4. AUTO BUY SECTION
local QtyInput = Instance.new("TextBox", MainFrame)
QtyInput.Size = UDim2.new(0.85, 0, 0, 30); QtyInput.Position = UDim2.new(0.075, 0, 0.45, 0)
QtyInput.PlaceholderText = "Beli berapa?"; QtyInput.Text = "2"
QtyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35); QtyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", QtyInput)

local BuyBtn = Instance.new("TextButton", MainFrame)
BuyBtn.Size = UDim2.new(0.85, 0, 0, 35); BuyBtn.Position = UDim2.new(0.075, 0, 0.56, 0)
BuyBtn.Text = "AUTO BUY (DEALER)"; BuyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); BuyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", BuyBtn)

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 25); Status.Position = UDim2.new(0, 0, 0.88, 0)
Status.Text = "Status: Idle"; Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.BackgroundTransparency = 1; Status.Font = Enum.Font.Gotham; Status.TextSize = 11

BuyBtn.MouseButton1Click:Connect(function()
    local amt = tonumber(QtyInput.Text) or 2
    task.spawn(function()
        Status.Text = "Status: Interacting..."
        if pressE_Global() then
            task.wait(2)
            if clickText("yea") or clickText("shop") then
                task.wait(1.5)
                local items = {"Gelatin", "Sugar Block Bag", "Water"}
                for _, item in pairs(items) do
                    Status.Text = "Status: Buying "..item
                    for i = 1, amt do 
                        if not clickText(item) then break end 
                        task.wait(0.4) 
                    end
                end
                Status.Text = "Status: Done Buying!"
            end
        end
        task.wait(2) Status.Text = "Status: Idle"
    end)
end)

-- 5. AUTO COOK SECTION
local CookBtn = Instance.new("TextButton", MainFrame)
CookBtn.Size = UDim2.new(0.85, 0, 0, 40); CookBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
CookBtn.Text = "START COOKING"; CookBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CookBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CookBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CookBtn)

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
            if safeEquip("Water") then 
                Status.Text = "Status: Inputting Water"; task.wait(0.3)
                pressE_Global() 
                for i=21,1,-1 do if not _G.AutoCook then break end Status.Text = "Water CD ("..i.."s)"; task.wait(1) end 
            end
            if _G.AutoCook and safeEquip("Sugar") then 
                Status.Text = "Status: Inputting Sugar"; task.wait(0.3)
                pressE_Global(); task.wait(2) 
            end
            if _G.AutoCook and safeEquip("Gelatin") then 
                Status.Text = "Status: Inputting Gelatin"; task.wait(0.3)
                pressE_Global(); task.wait(2) 
            end
            if _G.AutoCook then 
                for i=46,1,-1 do if not _G.AutoCook then break end Status.Text = "Cooking ("..i.."s)"; task.wait(1) end 
            end
            if _G.AutoCook and (safeEquip("Empty") or safeEquip("Jar")) then 
                Status.Text = "Status: Collecting MS..."; task.wait(0.3)
                pressE_Global(); task.wait(4) 
            end
        end
    end
end)

-- 6. STATS REFRESHER
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
            WaterCount.Text = "Water : "..w
            SugarCount.Text = "Sugar : "..s
            GelatinCount.Text = "Gelatin : "..g
            UnfinishedMS.Text = "⏳ Ready to Cook : "..math.min(w, s, g)
            FinishedMS.Text = "✅ Finished MS : "..fi
        end)
    end
end)

print("Automs By Fluu Loaded!")
