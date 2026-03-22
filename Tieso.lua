
local player = game.Players.LocalPlayer
local char, humanoid, root

local function loadChar()
    char = player.Character or player.CharacterAdded:Wait()
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
end

loadChar()
player.CharacterAdded:Connect(loadChar)

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

Instance.new("UICorner", button).CornerRadius = UDim.new(1,0)

-- Variables
local activo = false
local bv

button.MouseButton1Click:Connect(function()
    activo = not activo

    if activo then
        -- Reset limpio
        root.AssemblyAngularVelocity = Vector3.new(0,0,0)

        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = false
                v.CanCollide = true
            end
        end

        -- SOLO usa impulso si existe
        local vel = root.Velocity
        if vel.Magnitude < 1 then
            vel = Vector3.new(0,0,0) -- NO moverse
        end

        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(999999,999999,999999)
        bv.Velocity = vel
        bv.Parent = root

        humanoid.PlatformStand = true

        button.Text = "ON"

    else
        if bv then bv:Destroy() bv = nil end

        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

        root.AssemblyLinearVelocity = Vector3.new(0,0,0)
        root.AssemblyAngularVelocity = Vector3.new(0,0,0)

        button.Text = "Gravity"
    end
end)
