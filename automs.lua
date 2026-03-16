-- [[ AUTOMS BY FLUU - V7 ALL-IN-ONE FINAL ]]
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
Title.Text = "AUTOMS BY FLUU V7"
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

local function clickText(txt)
    local pGui = lp:WaitForChild("PlayerGui")
    for _, v in pairs(pGui:GetDescendants()) do
        if (v:IsA("TextButton") or v:IsA("TextLabel")) and v.Visible then
            if string.find(string.lower(v.Text), string.lower(txt)) then
                local target = v
                if v:IsA("TextLabel") and v.Parent:IsA("TextButton") then target = v.Parent end
                local pos = target.AbsolutePosition
                local size = target.AbsoluteSize
                VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2 + 58, 0, true, game, 1)
                task.wait(0.05)
                VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2 + 58, 0, false, game, 1)
                return true
            end
        end
    end
    return false
end

-- FUNGSI TAHAN E UNTUK POT
local function holdE_Action(holdTime)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    
    local root = char.HumanoidRootPart
    local targetPrompt = nil
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local dist = (root.Position - (v.Parent:IsA("BasePart") and v.Parent.Position or v.Parent:GetModelCFrame().Position)).Magnitude
            if dist < 15 then
                targetPrompt = v
                break
            end
        end
    end

    if targetPrompt then
        fireproximityprompt(targetPrompt)
        VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(holdTime or 0.2)
        VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        return true
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
            task.wait(1)
            return true
        end
    end
    return false
end

-- [[ BUTTONS & INPUTS ]]
local QtyInput = Instance.new("TextBox", MainFrame)
QtyInput.Size = UDim2.new(0.85, 0, 0, 30); QtyInput.Position = UDim2.new(0.075, 0, 0.45, 0)
QtyInput.PlaceholderText = "Beli berapa?"; QtyInput.Text = "100"
QtyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35); QtyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", QtyInput)

local BuyBtn = Instance.new("TextButton", MainFrame)
BuyBtn.Size = UDim2.new(0.85, 0, 0, 35); BuyBtn.Position = UDim2.new(0.075, 0, 0.56, 0)
BuyBtn.Text = "AUTO BUY (DEALER)"; BuyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); BuyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", BuyBtn)

local CookBtn = Instance.new("TextButton", MainFrame)
CookBtn.Size = UDim2.new(0.85, 0, 0, 40); CookBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
CookBtn.Text = "START COOKING"; CookBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CookBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CookBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CookBtn)

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 25); Status.Position = UDim2.new(0, 0, 0.88, 0)
Status.Text = "Status: Idle"; Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.BackgroundTransparency = 1; Status.Font = Enum.Font.Gotham; Status.TextSize = 11

-- [[ AUTO BUY LOGIC ]]
BuyBtn.MouseButton1Click:Connect(function()
    local amt = tonumber(QtyInput.Text) or 10
    task.spawn(function()
        Status.Text = "Status: Interacting..."
        if holdE_Action(0.3) then
            task.wait(2)
            if clickText("yea") then
                for i = 6, 1, -1 do Status.Text = "Status: Shop Open ("..i.."s)"; task.wait(1) end
                local items = {"Water", "Sugar", "Gelatin"}
                for _, item in pairs(items) do
                    Status.Text = "Status: Buying "..item
                    for i = 1, amt do if not clickText(item) then break end task.wait(0.35) end
                end
                Status.Text = "Status: Done Buying!"
            end
        end
        task.wait(2) Status.Text = "Status: Idle"
    end)
end)

-- STATS REFRESHER
local hasMaterials = false
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local w, s, g, fi = 0, 0, 0, 0
            local inv = lp.Backpack:GetChildren()
            if lp.Character then for _, v in pairs(lp.Character:GetChildren()) do if v:IsA("Tool") then table.insert(inv, v) end end end
            for _, item in pairs(inv) do
                local n = item.Name:lower()
