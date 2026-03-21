local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables
local savedPosition = nil
local noclip = false
local flying = false
local speed = 60

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ErikHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,180)
frame.Position = UDim2.new(0.3,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Erik"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

-- BOTONES
local function createButton(text, yPos)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.8,0,0,30)
    btn.Position = UDim2.new(0.1,0,0,yPos)
    btn.Text = text
    btn.BackgroundTransparency = 0.2
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    return btn
end

local tpBtn = createButton("TP", 40)
local tp2Btn = createButton("TP2", 80)
local trasBtn = createButton("tras", 120)
local flyBtn = createButton("fli", 160)

-- TP (guardar posición)
tpBtn.MouseButton1Click:Connect(function()
    savedPosition = root.Position
    tpBtn.Text = "Guardado ✔"
end)

-- TP2 (teletransportar)
tp2Btn.MouseButton1Click:Connect(function()
    if savedPosition then
        root.CFrame = CFrame.new(savedPosition)
    else
        tp2Btn.Text = "No guardado"
    end
end)

-- TRAS (noclip toggle)
RunService.Stepped:Connect(function()
    if noclip and char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

trasBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    trasBtn.Text = noclip and "tras ON" or "tras OFF"
end)

-- FLY
local bodyVel, bodyGyro

local function startFly()
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
    bodyVel.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bodyGyro.Parent = root
end

local function stopFly()
    if bodyVel then bodyVel:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

RunService.RenderStepped:Connect(function()
    if flying and bodyVel and bodyGyro then
        local cam = workspace.CurrentCamera
        bodyGyro.CFrame = cam.CFrame
        bodyVel.Velocity = cam.CFrame.LookVector * speed
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyBtn.Text = "fli ON"
        startFly()
    else
        flyBtn.Text = "fli OFF"
        stopFly()
    end
end)

-- RELOAD AL MORIR
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    root = char:WaitForChild("HumanoidRootPart")
end)
