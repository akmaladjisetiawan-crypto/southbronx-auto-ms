-- [[ AUTOMS BY FLUU - PREMIUM EDITION ]]
local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- CLEANUP UI LAMA
local uiName = "AutomsByFluuFinal"
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild(uiName) then game:GetService("CoreGui")[uiName]:Destroy() end
    if lp.PlayerGui:FindFirstChild(uiName) then lp.PlayerGui[uiName]:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = uiName

-- [[ UI DESIGN (PREMIUM DARK MODE) ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0) 
MainFrame.Size = UDim2.new(0, 240, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 255, 120)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "AUTOMS BY FLUU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- STATS PANEL (Box Dalam)
local StatsFrame = Instance.new("Frame", MainFrame)
StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
StatsFrame.Position = UDim2.new(0.07, 0, 0.12, 0)
StatsFrame.Size = UDim2.new(0.86, 0, 0, 115)
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 8)

local function createStat(txt, pos, color)
    local lbl = Instance.new("TextLabel", StatsFrame)
    lbl.Size = UDim2.new(1, -20, 0, 18)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.Text = txt
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local WaterVal = createStat("Water : 0", UDim2.new(0, 10, 0, 8))
local SugarVal = createStat("Sugar : 0", UDim2.new(0, 10, 0, 26))
local GelatinVal = createStat("Gelatin : 0", UDim2.new(0, 10, 0, 44))
local UnfinishedVal = createStat("⏳ Unfinished MS : 0", UDim2.new(0, 10, 0, 72), Color3.fromRGB(255, 180, 0))
local FinishedVal = createStat("✅ Finished MS : 0", UDim2.new(0, 10, 0, 92), Color3.fromRGB(0, 255, 120))

-- INPUT & BUTTONS
local QtyInput = Instance.new("TextBox", MainFrame)
QtyInput.Size = UDim2.new(0.86, 0, 0, 35); QtyInput.Position = UDim2.new(0.07, 0, 0.44, 0)
QtyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25); QtyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
QtyInput.Text = "2"; QtyInput.PlaceholderText = "Amount"; QtyInput.Font = Enum.Font.GothamMedium
Instance.new("UICorner", QtyInput)

local function createBtn(name, pos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.86, 0, 0, 40); btn.Position = pos
    btn.BackgroundColor3 = color; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 12
    Instance.new("UICorner", btn)
    return btn
end

local BuyBtn = createBtn("AUTO BUY (DEALER)", UDim2.new(0.07, 0, 0.56, 0), Color3.fromRGB(0, 150, 255))
local CookBtn = createBtn("START COOKING", UDim2.new(0.07, 0, 0.70, 0), Color3.fromRGB(220, 50, 50))

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 25); Status.Position = UDim2.new(0, 0, 0.9, 0)
Status.Text = "Status: Idle"; Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.BackgroundTransparency = 1; Status.Font = Enum.Font.Gotham; Status.TextSize = 10

-- [[ CORE FUNCTIONS ]]

local function forceInterract(target, holdTime)
    if not target then return end
    local prompt = target:FindFirstChildOfClass("ProximityPrompt") or target:FindFirstChild("ProximityPrompt", true)
    if prompt then
        fireproximityprompt(prompt)
        VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(holdTime or 0.5)
        VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        return true
    end
    return false
end

local function clickText(txt)
    local pGui = lp:WaitForChild("PlayerGui")
    for _, v in pairs(pGui:GetDescendants()) do
        if (v:IsA("TextButton") or v:IsA("TextLabel")) and v.Visible then
            if string.find(string.lower(v.Text), string.lower(txt)) then
                local target = v:IsA("TextLabel") and v.Parent or v
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

-- [[ LOGIC AUTO BUY ]]
BuyBtn.MouseButton1Click:Connect(function()
    local amt = tonumber(QtyInput.Text) or 2
    task.spawn(function()
        Status.Text = "Status: Searching Dealer..."
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and (lp.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude < 15 then
                forceInterract(v.Parent, 0.5)
                task.wait(1.5)
                if clickText("yea") or clickText("shop") then
                    for _, item in pairs({"Water", "Sugar", "Gelatin"}) do
                        Status.Text = "Status: Buying " .. item
                        for i = 1, amt do clickText(item) task.wait(0.3) end
                    end
                end
                break
            end
        end
        Status.Text = "Status: Buy Done!"; task.wait(2); Status.Text = "Status: Idle"
    end)
end)

-- [[ LOGIC AUTO COOK ]]
local cooking = false
CookBtn.MouseButton1Click:Connect(function()
    cooking = not cooking
    CookBtn.Text = cooking and "STOP COOKING" or "START COOKING"
    CookBtn.BackgroundColor3 = cooking and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(220, 50, 50)
    
    task.spawn(function()
        while cooking do
            Status.Text = "Status: Looking for Pot..."
            for _, obj in pairs(workspace:GetDescendants()) do
                if not cooking then break end
                local name = obj.Name:lower()
                if (name == "stove" or name == "pot") and (obj:IsA("BasePart") or obj:IsA("Model")) then
                    local root = lp.Character.HumanoidRootPart
                    local pos = obj:IsA("Model") and obj:GetModelCFrame().Position or obj.Position
                    if (root.Position - pos).Magnitude < 12 then
                        Status.Text = "Status: Cooking..."
                        forceInterract(obj, 0.6)
                        task.wait(0.5)
                        clickText("Cook")
                        clickText("Make")
                        task.wait(2)
                    end
                end
            end
            task.wait(1)
        end
        Status.Text = "Status: Idle"
    end)
end)

task.spawn(function()
    while task.wait(3) do
    end
end)

print("AUTOMS BY FLUU - LOADED SUCCESSFULLY")
