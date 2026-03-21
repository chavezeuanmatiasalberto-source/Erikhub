

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- GUI
local screenGui = Instance.new("ScreenGui", game.CoreGui)

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 120, 0, 120)
button.Position = UDim2.new(0.8, 0, 0.6, 0)
button.Text = "Gravity"
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true

-- Circular
local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(1, 0)

-- Variables
local activo = false
local bodyVel
local bodyGyro

button.MouseButton1Click:Connect(function()
    activo = not activo

    if activo then
        -- DESANCLAR TODO
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = false
            end
        end

        -- SIN GRAVEDAD
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Parent = root
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        bodyVel.MaxForce = Vector3.new(999999, 999999, 999999)

        -- RÍGIDO (tieso)
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Parent = root
        bodyGyro.MaxTorque = Vector3.new(999999, 999999, 999999)
        bodyGyro.CFrame = root.CFrame

        humanoid.PlatformStand = true

        button.Text = "ON"

    else
        -- RESTAURAR
        if bodyVel then bodyVel:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end

        humanoid.PlatformStand = false

        button.Text = "Gravity"
    end
end)
