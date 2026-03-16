-- AUTOMS BY FLUU - SOUTH BRONX
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CookToggle = Instance.new("TextButton")
local BuyToggle = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local StatsFrame = Instance.new("Frame")

_G.AutoCook = false
_G.AutoBuy = false

local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- Setup UI (AUTOMS BY FLUU)
ScreenGui.Name = "AutomsByFluuHub"
ScreenGui.Parent = game:GetService("CoreGui") or lp:WaitForChild("PlayerGui")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -125)
MainFrame.Size = UDim2.new(0, 230, 350)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(0, 255, 150)
stroke.Thickness = 2

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AUTOMS BY FLUU v6"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

StatsFrame.Parent = MainFrame
StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
StatsFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
StatsFrame.Size = UDim2.new(0.9, 0, 0, 110)
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 8)

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

local WaterCount = createStatLabel("Water", UDim2.new(0, 10, 0, 5))
local SugarCount = createStatLabel("Sugar", UDim2.new(0, 10, 0, 25))
local GelatinCount = createStatLabel("Gelatin", UDim2.new(0, 10, 0, 45))
local UnfinishedMS = createStatLabel("⏳ Raw MS", UDim2.new(0, 10, 0, 65), Color3.fromRGB(255, 165, 0))
local FinishedMS = createStatLabel("✅ Ready MS", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 255, 150))

CookToggle.Parent = MainFrame
CookToggle.Position = UDim2.new(0.1, 0, 0.46, 0)
CookToggle.Size = UDim2.new(0.8, 0, 0, 35)
CookToggle.Text = "AUTO COOK: OFF"
CookToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CookToggle.Font = Enum.Font.GothamBold
CookToggle.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CookToggle)

BuyToggle.Parent = MainFrame
BuyToggle.Position = UDim2.new(0.1, 0, 0.58, 0)
BuyToggle.Size = UDim2.new(0.8, 0, 0, 35)
BuyToggle.Text = "AUTO BUY: OFF"
BuyToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
BuyToggle.Font = Enum.Font.GothamBold
BuyToggle.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", BuyToggle)

local BuyBox = Instance.new("TextBox", MainFrame)
BuyBox.Size = UDim2.new(0.8, 0, 0, 30)
BuyBox.Position = UDim2.new(0.1, 0, 0.71, 0)
BuyBox.PlaceholderText = "Beli Berapa? (Default 10)"
BuyBox.Text = "10"
BuyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BuyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", BuyBox)

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0.93, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 10

local currentW, currentS, currentG = 0, 0, 0

local function pressE()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and (lp.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude < 12 then
            fireproximityprompt(v)
        end
    end
end

-- Fungsi khusus Bypass Dialog NPC South Bronx
local function buyItemSouthBronx(itemName)
    StatusLabel.Text = "Status: Dialog dengan NPC..."
    
    -- 1. Tekan E ke NPC
    pressE()
    task.wait(0.8)
    
    -- 2. Bypass Dialog "Yea.. you the guy?"
    -- Kita mencari objek UI Dialog dan menekan tombolnya secara programmatik
    pcall(function()
        local playerGui = lp:WaitForChild("PlayerGui")
        -- Mencari tombol dialog "Yea.. you the guy?"
        for _, v in pairs(playerGui:GetDescendants()) do
            if v:IsA("TextButton") and (v.Text:find("Yea") or v.Text:find("guy")) then
                -- Simulasi klik pada pilihan dialog
                local pos = v.AbsolutePosition + (v.AbsoluteSize / 2)
                VIM:SendMouseButtonEvent(pos.X, pos.Y + 36, 0, true, game, 1)
                VIM:SendMouseButtonEvent(pos.X, pos.Y + 36, 0, false, game, 1)
                task.wait(0.5)
            end
        end
    end)

    -- 3. Eksekusi Pembelian
    StatusLabel.Text = "Status: Membeli "..itemName
    pcall(function()
        local amount = tonumber(BuyBox.Text) or 10
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("BuyItem", true) or 
                       game:GetService("ReplicatedStorage"):FindFirstChild("Purchase", true)
        
        if remote then
            for i = 1, amount do
                remote:FireServer(itemName)
                task.wait(0.1)
            end
        end
    end)
    task.wait(1)
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

-- Toggles & Stats Loop
CookToggle.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    CookToggle.Text = _G.AutoCook and "AUTO COOK: ON" or "AUTO COOK: OFF"
    CookToggle.BackgroundColor3 = _G.AutoCook and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
end)

BuyToggle.MouseButton1Click:Connect(function()
    _G.AutoBuy = not _G.AutoBuy
    BuyToggle.Text = _G.AutoBuy and "AUTO BUY: ON" or "AUTO BUY: OFF"
    BuyToggle.BackgroundColor3 = _G.AutoBuy and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
end)

spawn(function()
    while true do
        pcall(function()
            local items = lp.Backpack:GetChildren()
            if lp.Character then for _, v in pairs(lp.Character:GetChildren()) do if v:IsA("Tool") then table.insert(items, v) end end end
            local w, s, g, un, fi = 0, 0, 0, 0, 0
            for _, item in pairs(items) do
                local n = item.Name:lower()
                if n:find("water") then w = w + 1
                elseif (n:find("sugar") or n:find("block")) and not n:find("empty") then s = s + 1
                elseif n:find("gelatin") then g = g + 1
                elseif n:find("marshmallow") then
                    if n:find("unfinish") or n:find("raw") then un = un + 1 else fi = fi + 1 end
                end
            end
            currentW, currentS, currentG = w, s, g
            WaterCount.Text = "Water : "..w
            SugarCount.Text = "Sugar : "..s
            GelatinCount.Text = "Gelatin : "..g
            UnfinishedMS.Text = "⏳ Raw MS : "..un
            FinishedMS.Text = "✅ Ready MS : "..fi
        end)
        task.wait(2)
    end
end)

-- Loop Auto Buy
spawn(function()
    while true do
        task.wait(1.5)
        if _G.AutoBuy then
            if currentW == 0 then buyItemSouthBronx("Water") end
            if currentS == 0 then buyItemSouthBronx("Sugar Block Bag") end
            if currentG == 0 then buyItemSouthBronx("Gelatin") end
        end
    end
end)

-- Loop Auto Cook
spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoCook then
            if autoEquip("Water") then
                StatusLabel.Text = "Status: Input Water"
                pressE()
                for i = 21, 1, -1 do if not _G.AutoCook then break end StatusLabel.Text = "Status: Water CD ("..i.."s)" task.wait(1) end
            end
            if _G.AutoCook and autoEquip("Sugar") then
                StatusLabel.Text = "Status: Input Sugar"
                pressE()
                task.wait(1.8)
            end
            if _G.AutoCook and autoEquip("Gelatin") then
                StatusLabel.Text = "Status: Input Gelatin"
                pressE()
                task.wait(1.8)
            end
            if _G.AutoCook then
                for i = 46, 1, -1 do if not _G.AutoCook then break end StatusLabel.Text = "Status: Cooking ("..i.."s)" task.wait(1) end
            end
            if _G.AutoCook and autoEquip("Empty") then
                StatusLabel.Text = "Status: Collecting..."
                pressE()
                task.wait(4)
            end
        else
            StatusLabel.Text = "Status: Idle"
        end
    end
end)
