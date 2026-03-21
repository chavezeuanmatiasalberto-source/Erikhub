

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- BOTON RUN
local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(0,120,0,50)
runBtn.Position = UDim2.new(0,20,1,-80)
runBtn.Text = "RUN"
runBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
runBtn.TextScaled = true
runBtn.Parent = screenGui

-- BOTON TAUNT
local tauntBtn = Instance.new("TextButton")
tauntBtn.Size = UDim2.new(0,120,0,50)
tauntBtn.Position = UDim2.new(0,160,1,-80)
tauntBtn.Text = "TAUNT"
tauntBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 255)
tauntBtn.TextScaled = true
tauntBtn.Parent = screenGui

-- VARIABLES
local running = false
local speed = 16

-- FUNCION CORRER (Mach system)
local function startRun()
	if running then return end
	running = true
	
	while running do
		speed = speed + 2
		
		-- niveles tipo Mach
		if speed >= 30 then
			print("Mach 1")
		end
		if speed >= 60 then
			print("Mach 2")
		end
		if speed >= 100 then
			print("Mach 3")
		end
		if speed >= 150 then
			print("Mach 4")
		end
		if speed >= 200 then
			print("MACH 5 MAX")
			speed = 200
		end
		
		humanoid.WalkSpeed = speed
		
		-- animacion simple (simulada)
		humanoid.CameraOffset = Vector3.new(
			math.random(-1,1)/5,
			math.random(-1,1)/5,
			0
		)
		
		wait(0.2)
	end
end

-- DETENER
local function stopRun()
	running = false
	speed = 16
	humanoid.WalkSpeed = 16
	humanoid.CameraOffset = Vector3.new(0,0,0)
end

-- TAUNT SIMPLE
local function taunt()
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://507770239" -- animación default
	
	local track = humanoid:LoadAnimation(anim)
	track:Play()
	
	-- efecto gracioso
	for i = 1,10 do
		char.Head.Orientation = Vector3.new(0, i*36, 0)
		wait(0.05)
	end
	
	track:Stop()
	char.Head.Orientation = Vector3.new(0,0,0)
end

-- EVENTOS
runBtn.MouseButton1Click:Connect(function()
	if running then
		stopRun()
	else
		startRun()
	end
end)

tauntBtn.MouseButton1Click:Connect(function()
	taunt()
end)
