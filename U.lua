

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0,120,0,120)
button.Position = UDim2.new(0.8,0,0.6,0)
button.Text = "Gravity"
button.BackgroundColor3 = Color3.fromRGB(0,0,0)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.TextScaled = true

local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(1,0)

-- Variables
local activo = false
local bv, bg
local speed = 50
local moveDir = Vector3.new()

-- Movimiento (WASD / móvil detecta joystick)
local function getMoveDirection()
    return humanoid.MoveDirection
end

button.MouseButton1Click:Connect(function()
    activo = not activo

    if activo then
        -- DESANCLAR
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = false
            end
        end

        -- SIN GRAVEDAD
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1,1,1) * 999999
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = root

        -- RÍGIDO
        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1,1,1) * 999999
        bg.CFrame = root.CFrame
        bg.Parent = root

        humanoid.PlatformStand = true

        -- LOOP MOVIMIENTO
        RunService.RenderStepped:Connect(function()
            if activo and bv then
                moveDir = getMoveDirection()
                bv.Velocity = moveDir * speed
                bg.CFrame = workspace.CurrentCamera.CFrame
            end
        end)

        button.Text = "ON"

    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end

        humanoid.PlatformStand = false
        button.Text = "Gravity"
    end
end)
