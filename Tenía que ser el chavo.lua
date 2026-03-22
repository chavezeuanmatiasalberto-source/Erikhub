
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0,120,0,120)
button.Position = UDim2.new(1, -130, 0, 10)
button.Text = "Gravity"
button.BackgroundColor3 = Color3.fromRGB(0,0,0)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.TextScaled = true

local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(1,0)

-- Variables
local activo = false
local bv

-- Velocidad inicial
local velocity = Vector3.new(50,20,30)

button.MouseButton1Click:Connect(function()
    activo = not activo

    if activo then
        -- Preparar personaje
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = false
                v.CanCollide = true
            end
        end

        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = velocity
        bv.Parent = root

        humanoid.PlatformStand = true
        button.Text = "ON"

        -- Rebote físico real
        root.Touched:Connect(function(hit)
            if activo and bv and hit.CanCollide then
                local normal = (root.Position - hit.Position).Unit
                velocity = (velocity - 2 * velocity:Dot(normal) * normal) * 0.9 -- rebote con fricción
                bv.Velocity = velocity
            end
        end)

        -- Mantener rotación libre
        RunService.RenderStepped:Connect(function()
            if activo and bv then
                bv.Velocity = velocity
            end
        end)

    else
        if bv then bv:Destroy() end
        humanoid.PlatformStand = false
        button.Text = "Gravity"
    end
end)
