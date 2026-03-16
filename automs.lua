-- AUTOMS BY FLUU - SOUTH BRONX
local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- Cleanup UI
local oldUI = game:GetService("CoreGui"):FindFirstChild("AutomsByFluuFinal") or lp.PlayerGui:FindFirstChild("AutomsByFluuFinal")
if oldUI then oldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutomsByFluuFinal"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

-- [[ UI DESIGN ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -190)
MainFrame.Size = UDim2.new(0, 230, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 5
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AUTOMS BY FLUU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextSize = 14
Title.ZIndex = 10

-- STATS PANEL
local StatsFrame = Instance.new("Frame", MainFrame)
StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
StatsFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
StatsFrame.Size = UDim2.new(0.9, 0, 0, 105)
StatsFrame.ZIndex = 6
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
    lbl.ZIndex = 10
    return lbl
end

local WaterCount = createStatLabel("Water", UDim2.new(0, 10, 0, 5))
local SugarCount = createStatLabel("Sugar", UDim2.new(0, 10, 0, 23))
local GelatinCount = createStatLabel("Gelatin", UDim2.new(0, 10, 0, 41))
local UnfinishedMS = createStatLabel("⏳ Unfinished MS", UDim2.new(0, 10, 0, 62), Color3.fromRGB(255, 165, 0))
local FinishedMS = createStatLabel("✅ Finished MS", UDim2.new(0, 10, 0, 80), Color3.fromRGB(0, 255, 150))

-- INPUT & BUTTONS
local QtyInput = Instance.new("TextBox", MainFrame)
QtyInput.Size = UDim2.new(0.85, 0, 0, 30)
QtyInput.Position = UDim2.new(0.075, 0, 0.45, 0)
QtyInput.PlaceholderText = "Beli berapa?"
QtyInput.Text = "100"
QtyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
QtyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
QtyInput.ZIndex = 10
Instance.new("UICorner", QtyInput)

local BuyBtn = Instance.new("TextButton", MainFrame)
BuyBtn.Size = UDim2.new(0.85, 0, 0, 35)
BuyBtn.Position = UDim2.new(0.075, 0, 0.56, 0)
BuyBtn.Text = "AUTO BUY (DEALER)"
BuyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyBtn.Font = Enum.Font.GothamBold
BuyBtn.ZIndex = 10
Instance.new("UICorner", BuyBtn)

local CookBtn = Instance.new("TextButton", MainFrame)
CookBtn.Size = UDim2.new(0.85, 0, 0, 40)
CookBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
CookBtn.Text = "START COOKING"
CookBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CookBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CookBtn.Font = Enum.Font.GothamBold
CookBtn.ZIndex = 10
Instance.new("UICorner", CookBtn)

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Position = UDim2.new(0, 0, 0.88, 0)
Status.Text = "Status: Idle"
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.ZIndex = 10

-- [[ FUNCTIONS ]]

local function clickText(txt)
    local pGui = lp:WaitForChild("PlayerGui")
    for _, v in pairs(pGui:GetDescendants()) do
        if v:IsA("TextButton") and v.Visible and string.find(string.lower(v.Text), string.lower(txt)) then
            local pos = v.AbsolutePosition
            local size = v.AbsoluteSize
            -- Offset 58 khusus Laptop
            VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2 + 58, 0, true, game, 1)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2 + 58, 0, false, game, 1)
            return true
        end
    end
    return false
end

local function pressE(targetName)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local parent = v.Parent
            local match = false
            
            -- Lamont (dealer)
            if targetName then
                local n = parent.Name:lower()
                local t = v.ActionText:lower()
                if n:find(targetName:lower()) or n:find("dealer") or t:find("talk") or t:find("interact") then
                    match = true
                end
            else
                -- Untuk masak (mencari Kompor)
                if v.ActionText:lower():find("cook") or parent.Name:lower():find("stove") then
                    match = true
                end
            end

            if match then
                local targetPos = (parent:IsA("Model") and parent:GetModelCFrame().Position) or parent.Position
                local dist = (char.HumanoidRootPart.Position - targetPos).Magnitude
                if dist < 15 then 
                    fireproximityprompt(v) 
                    return true 
                end
            end
        end
    end
    return false
end

-- [[ LOGIC ]]

_G.AutoCook = false

-- Stats Loop
task.spawn(function()
    while task.wait(1.5) do
        pcall(function()
            local w, s, g, un, fi = 0, 0, 0, 0, 0
            local inv = lp.Backpack:GetChildren()
            if lp.Character then for _, v in pairs(lp.Character:GetChildren()) do if v:IsA("Tool") then table.insert(inv, v) end end end
            for _, item in pairs(inv) do
                local n = item.Name:lower()
                if n:find("water") then w = w + 1
                elseif n:find("sugar") and not n:find("empty") then s = s + 1
                elseif n:find("gelatin") then g = g + 1
                elseif n:find("marshmallow") then
                    if n:find("unfinish") or n:find("raw") then un = un + 1 else fi = fi + 1 end
                end
            end
            WaterCount.Text = "Water : "..w
            SugarCount.Text = "Sugar : "..s
            GelatinCount.Text = "Gelatin : "..g
            UnfinishedMS.Text = "⏳ Unfinished MS : "..un
            FinishedMS.Text = "✅ Finished MS : "..fi
        end)
    end
end)

-- BUY Logic
BuyBtn.MouseButton1Click:Connect(function()
    local amt = tonumber(QtyInput.Text) or 10
    task.spawn(function()
        Status.Text = "Status: Interacting with Dealer..."
        -- Mencoba mencari Lamont atau Dealer di sekitar
        if pressE("Lamont") then
            task.wait(1.5)
            if clickText("yea") then
                task.wait(1.5)
                local list = {"Water", "Sugar Block Bag", "Gelatin"}
                for _, item in pairs(list) do
                    Status.Text = "Status: Buying "..item
                    for i = 1, amt do
                        clickText(item)
                        task.wait(0.35)
                    end
                end
                Status.Text = "Status: Done Buying!"
            else
                Status.Text = "Status: Dialog Not Found"
            end
        else
            Status.Text = "Status: Lamont Not Found"
        end
        task.wait(2) Status.Text = "Status: Idle"
    end)
end)

-- COOK Logic
CookBtn.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    CookBtn.Text = _G.AutoCook and "STOP COOKING" or "START COOKING"
    CookBtn.BackgroundColor3 = _G.AutoCook and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

local function autoEquip(n)
    local b = lp.Backpack
    local c = lp.Character
    if not b or not c then return false end
    c.Humanoid:UnequipTools() task.wait(0.2)
    for _, t in pairs(b:GetChildren()) do
        if t.Name:lower():find(n:lower()) then c.Humanoid:EquipTool(t) task.wait(0.4) return true end
    end
    return false
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoCook then
            if autoEquip("Water") then 
                Status.Text = "Status: Water" pressE() 
                for i=21,1,-1 do if not _G.AutoCook then break end Status.Text="Water CD("..i.."s)" task.wait(1) end 
            end
            if _G.AutoCook and autoEquip("Sugar") then Status.Text="Status: Sugar" pressE() task.wait(3) end
            if _G.AutoCook and autoEquip("Gelatin") then Status.Text="Status: Gelatin" pressE() task.wait(3) end
            if _G.AutoCook then 
                for i=46,1,-1 do if not _G.AutoCook then break end Status.Text="Cooking("..i.."s)" task.wait(1) end 
            end
            if _G.AutoCook and autoEquip("Empty") then Status.Text="Status: Collecting" pressE() task.wait(5) end
        end
    end
end)
