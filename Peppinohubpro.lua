

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local lighting = game:GetService("Lighting")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PeppinoGod"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 140)
frame.Position = UDim2.new(0.05, 0, 0.65, 0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BackgroundTransparency = 0.25
frame.Active = true
frame.Draggable = true

-- UI CORNER
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 20)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,25)
title.Text = "PEPPINO GOD"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

-- FUNCION CREAR BOTON CIRCULAR
local function createCircleButton(text, posX)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0,60,0,60)
	btn.Position = UDim2.new(0,posX,0,50)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(255,80,80)
	btn.TextScaled = true
	
	local uic = Instance.new("UICorner", btn)
	uic.CornerRadius = UDim.new(1,0) -- círculo
	
	return btn
end

-- BOTONES
local runBtn = createCircleButton("RUN", 10)
local dashBtn = createCircleButton("DASH", 85)
local tauntBtn = createCircleButton("TAUNT", 160)

-- VARIABLES
local running = false
local speed = 16
local maxSpeed = 220

-- BLUR
local blur = Instance.new("BlurEffect", lighting)
blur.Size = 0

-- TRAIL
local attachment0 = Instance.new("Attachment", root)
local attachment1 = Instance.new("Attachment", root)

local trail = Instance.new("Trail", root)
trail.Attachment0 = attachment0
trail.Attachment1 = attachment1
trail.Lifetime = 0.2
trail.Enabled = false

-- RUN SYSTEM
local function runSystem()
	while running do
		speed = math.clamp(speed + 4, 16, maxSpeed)
		humanoid.WalkSpeed = speed

		-- MACH LEVEL
		if speed >= 200 then
			runBtn.Text = "M5"
		elseif speed >= 150 then
			runBtn.Text = "M4"
		elseif speed >= 100 then
			runBtn.Text = "M3"
		elseif speed >= 60 then
			runBtn.Text = "M2"
		elseif speed >= 30 then
			runBtn.Text = "M1"
		end

		-- EFECTOS
		camera.FieldOfView = 70 + (speed / 4)
		blur.Size = speed / 10
		trail.Enabled = speed > 80

		humanoid.CameraOffset = Vector3.new(
			math.random(-3,3)/10,
			math.random(-3,3)/10,
			0
		)

		task.wait(0.08)
	end
end

-- STOP
local function stopRun()
	running = false
	speed = 16
	humanoid.WalkSpeed = 16
	camera.FieldOfView = 70
	blur.Size = 0
	trail.Enabled = false
	humanoid.CameraOffset = Vector3.new(0,0,0)
	runBtn.Text = "RUN"
end

-- DASH
local function dash()
	if not running then return end
	
	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1,0,1) * 50000
	bv.Velocity = root.CFrame.LookVector * 200
	bv.Parent = root
	
	wait(0.2)
	bv:Destroy()
end

-- TAUNT
local function taunt()
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://507770239"
	
	local track = humanoid:LoadAnimation(anim)
	track:Play()

	for i = 1, 15 do
		char.Head.Orientation = Vector3.new(0, i*24, 0)
		task.wait(0.02)
	end

	track:Stop()
	char.Head.Orientation = Vector3.new(0,0,0)
end

-- EVENTOS
runBtn.MouseButton1Click:Connect(function()
	running = not running
	if running then
		runSystem()
	else
		stopRun()
	end
end)

dashBtn.MouseButton1Click:Connect(dash)
tauntBtn.MouseButton1Click:Connect(taunt)
