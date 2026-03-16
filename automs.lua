-- AUTOMS BY FLUU - SOUTH BRONX
local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- Cleanup GUI
if game.CoreGui:FindFirstChild("AutomsByFluuFinal") then
    game.CoreGui.AutomsByFluuFinal:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutomsByFluuFinal"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -200)
MainFrame.Size = UDim2.new(0, 230, 420)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AUTOMS BY FLUU v18"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextSize = 14

local StatsFrame = Instance.new("Frame", MainFrame)
StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
StatsFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
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
    lbl.TextSize = 11
    lbl.Text = name .. " : 0"
    return lbl
end

-- Bahan
local WaterCount = createStatLabel("Water", UDim2.new(0, 10, 0, 5))
local SugarCount = createStatLabel("Sugar", UDim2.new(0, 10, 0, 25))
local GelatinCount = createStatLabel("Gelatin", UDim2.new(0, 10, 0, 45))

-- Status Marshmallow
local UnfinishedMS = createStatLabel("⏳ Unfinished MS", UDim2.new(0, 10, 0, 65), Color3.fromRGB(255, 165, 0))
local FinishedMS = createStatLabel("✅ Finished MS", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 255, 150))

local QtyInput = Instance.new("TextBox", MainFrame)
QtyInput.Size = UDim2.new(0.85, 0, 0, 35)
QtyInput.Position = UDim2.new(0.075, 0, 0.4, 0)
QtyInput.PlaceholderText = "Jumlah beli per item"
QtyInput.Text = "100"
QtyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
QtyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", QtyInput)

local ExecuteBuy = Instance.new("TextButton", MainFrame)
ExecuteBuy.Size = UDim2.new(0.85, 0, 0, 40)
ExecuteBuy.Position = UDim2.new(0.075, 0, 0.51, 0)
ExecuteBuy.Text = "AUTO BUY"
ExecuteBuy.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ExecuteBuy.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBuy.Font = Enum.Font.GothamBold
Instance.new("UICorner", ExecuteBuy)

local CookBtn = Instance.new("TextButton", MainFrame)
CookBtn.Size = UDim2.new(0.85, 0, 0, 45)
CookBtn.Position = UDim2.new(0.075, 0, 0.7, 0)
CookBtn.Text = "START COOKING"
CookBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CookBtn.Font = Enum.Font.GothamBold
CookBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", CookBtn)

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.9, 0)
Status.Text = "Status: Idle"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 10

_G.AutoCook = false

-- Monitor Loop
spawn(function()
    while true do
        pcall(function()
            local items = lp.Backpack:GetChildren()
            if lp.Character then for _, v in pairs(lp.Character:GetChildren()) do if v:IsA("Tool") then table.insert(items, v) end end end
            local w, s, g, un, fi = 0, 0, 0, 0, 0
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
        task.wait(1.5)
    end
end)

local function clickDialog()
    pcall(function()
        local pg = lp:WaitForChild("PlayerGui")
        for _, v in pairs(pg:GetDescendants()) do
            if v:IsA("TextButton") and (v.Text:find("Yea") or v.Text:find("guy")) then
                local x, y = v.AbsolutePosition.X + v.AbsoluteSize.X/2, v.AbsolutePosition.Y + v.AbsoluteSize.Y/2
                VIM:SendMouseButtonEvent(x, y + 36, 0, true, game, 1)
                VIM:SendMouseButtonEvent(x, y + 36, 0, false, game, 1)
            end
        end
    end)
end

local function pressE()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local dist = (lp.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude
            if dist < 12 then fireproximityprompt(v) end
        end
    end
end

local function autoEquip(name)
    local bp = lp:FindFirstChild("Backpack")
    local char = lp.Character
    if not bp or not char then return false end
    char.Humanoid:UnequipTools()
    task.wait(0.2)
    for _, tool in pairs(bp:GetChildren()) do
        if string.find(string.lower(tool.Name), string.lower(name)) then
            char.Humanoid:EquipTool(tool)
            task.wait(0.4)
            return true
        end
    end
    return false
end

-- Event Auto Buy
ExecuteBuy
