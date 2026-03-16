-- AUTOMS BY FLUU
local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- Bersihkan UI
local oldUI = game:GetService("CoreGui"):FindFirstChild("AutomsByFluuFinal") or lp.PlayerGui:FindFirstChild("AutomsByFluuFinal")
if oldUI then oldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutomsByFluuFinal"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- Biar ga tumpang tindih eror
local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

-- FRAME UTAMA (KOTAK RAPI)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
MainFrame.Size = UDim2.new(0, 220, 320) -- Ukuran kotak proporsional
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 2

-- TITLE
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "AUTOMS BY FLUU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- CONTAINER STATS (DASHBOARD)
local StatsFrame = Instance.new("Frame", MainFrame)
StatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
StatsFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
StatsFrame.Size = UDim2.new(0.9, 0, 0, 100)
Instance.new("UICorner", StatsFrame)

local function createStat(name, pos, color)
    local lbl = Instance.new("TextLabel", StatsFrame)
    lbl.Size = UDim2.new(1, -10, 0, 18)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.Text = name .. " : 0"
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local WaterCount = createStat("Water", UDim2.new(0, 10, 0, 5))
local SugarCount = createStat("Sugar", UDim2.new(0, 10, 0, 23))
local GelatinCount = createStat("Gelatin", UDim2.new(0, 10, 0, 41))
local UnfinishedMS = createStat("⏳ Unfinished MS", UDim2.new(0, 10, 0, 62), Color3.fromRGB(255, 165, 0))
local FinishedMS = createStat("✅ Finished MS", UDim2.new(0, 10, 0, 80), Color3.fromRGB(0, 255, 150))

-- INPUT BOX
local QtyInput = Instance.new("TextBox", MainFrame)
QtyInput.Size = UDim2.new(0.9, 0, 0, 30)
QtyInput.Position = UDim2.new(0.05, 0, 0.5, 0)
QtyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
QtyInput.Text = "100"
QtyInput.PlaceholderText = "Amount"
QtyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", QtyInput)

-- BUTTON AUTO BUY
local BuyBtn = Instance.new("TextButton", MainFrame)
BuyBtn.Size = UDim2.new(0.9, 0, 0, 35)
BuyBtn.Position = UDim2.new(0.05, 0, 0.62, 0)
BuyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
BuyBtn.Text = "AUTO BUY"
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", BuyBtn)

-- BUTTON START COOKING
local CookBtn = Instance.new("TextButton", MainFrame)
CookBtn.Size = UDim2.new(0.9, 0, 0, 35)
CookBtn.Position = UDim2.new(0.05, 0, 0.76, 0)
CookBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CookBtn.Text = "START COOKING"
CookBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CookBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CookBtn)

-- STATUS LABEL
local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0.9, 0)
Status.BackgroundTransparency = 1
Status.Text = "Status: Idle"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.Font = Enum.Font.Gotham
Status.TextSize = 9

_G.AutoCook = false

-- Update Stats
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local w, s, g, un, fi = 0, 0, 0, 0, 0
            local items = lp.Backpack:GetChildren()
            if lp.Character then for _, v in pairs(lp.Character:GetChildren()) do if v:IsA("Tool") then table.insert(items, v) end end end
            for _, item in pairs(items) do
                local n = item.Name:lower()
                if n:find("water") then w = w + 1
                elseif n:find("sugar") then s = s + 1
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

-- Buy Logic
BuyBtn.MouseButton1Click:Connect(function()
    local amount = tonumber(QtyInput.Text) or 100
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and (v.Parent.Name:find("Lamont") or v.Parent.Name:find("Bell")) then
            fireproximityprompt(v)
            task.wait(1)
            -- Dialog Auto Clicker
            pcall(function()
                local pg = lp:WaitForChild("PlayerGui")
                for _, b in pairs(pg:GetDescendants()) do
                    if b:IsA("TextButton") and (b.Text:find("Yea") or b.Text:find("guy")) then
                        local x, y = b.AbsolutePosition.X + b.AbsoluteSize.X/2, b.AbsolutePosition.Y + b.AbsoluteSize.Y/2
                        VIM:SendMouseButtonEvent(x, y + 36, 0, true, game, 1)
                        VIM:SendMouseButtonEvent(x, y + 36, 0, false, game, 1)
                    end
                end
            end)
            task.wait(1)
            local rem = game:GetService("ReplicatedStorage"):FindFirstChild("BuyItem", true) or game:GetService("ReplicatedStorage"):FindFirstChild("Purchase", true)
            if rem then
                task.spawn(function()
                    Status.Text = "Status: Buying..."
                    for i = 1, amount do rem:FireServer("Water") task.wait(0.1) end
                    for i = 1, amount do rem:FireServer("Sugar Block Bag") task.wait(0.1) end
                    for i = 1, amount do rem:FireServer("Gelatin") task.wait(0.1) end
                    Status.Text = "Status: Done Shopping"
                end)
            end
            break
        end
    end
end)

CookBtn.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    CookBtn.Text = _G.AutoCook and "STOP COOKING" or "START COOKING"
    CookBtn.BackgroundColor3 = _G.AutoCook and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)
