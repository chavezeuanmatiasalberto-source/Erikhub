

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- GUI (FIX: PlayerGui)
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
local bv, bg

button.MouseButton1Click:Connect(function()
    activo = not activo

    if activo then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = false
            end
        end

        local impulso = root.Velocity

        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(999999,999999,999999)
        bv.Velocity = impulso
        bv.Parent = root

        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(999999,999999,999999)
        bg.CFrame = root.CFrame
        bg.Parent = root

        humanoid.PlatformStand = true
        button.Text = "ON"

    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end

        humanoid.PlatformStand = false
        button.Text = "Gravity"
    end
end)
