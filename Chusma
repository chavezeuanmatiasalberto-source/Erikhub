--// Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ERIK GOD 2.5 😈",
   LoadingTitle = "IA COMPLETA...",
   LoadingSubtitle = "Optimized",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ERIK_GOD",
      FileName = "V25"
   }
})

--// Servicios
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

--// CONFIG
local API_KEY = ""
local API_URL = "https://tu-proxy.com/groq"

local aiEnabled = false
local cooldown = false
local personality = "normal"

local memory = {}

--// UI
local Tab = Window:CreateTab("🤖 IA")

Tab:CreateInput({
   Name = "API KEY",
   PlaceholderText = "Pon tu API key",
   Callback = function(v)
      API_KEY = v
   end,
})

Tab:CreateToggle({
   Name = "Activar IA",
   CurrentValue = false,
   Callback = function(v)
      aiEnabled = v
   end,
})

Tab:CreateDropdown({
   Name = "Personalidad",
   Options = {"normal","divertido","sabio","troll"},
   CurrentOption = "normal",
   Callback = function(opt)
      personality = opt
   end,
})

--// UTIL
local function getHRP(char)
	return char and char:FindFirstChild("HumanoidRootPart")
end

--// 🎭 EMOCIONES
local animations = {
	happy = "507771019",
	sad = "507770239",
	angry = "507770453"
}

local function playEmotion(animId)
	local hum = player.Character and player.Character:FindFirstChild("Humanoid")
	if not hum then return end

	local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://"..animId

	animator:LoadAnimation(anim):Play()
end

local function getEmotion(mood)
	if mood=="dopamina" then return "happy"
	elseif mood=="malo" then return "angry"
	elseif mood=="muy_malo" then return "sad"
	end
	return "happy"
end

--// 👁️ REACCIONES
local function lookAt(plr)
	local myHRP = getHRP(player.Character)
	local tHRP = getHRP(plr.Character)
	if myHRP and tHRP then
		myHRP.CFrame = CFrame.new(myHRP.Position, tHRP.Position)
	end
end

local function moveTo(plr,mode)
	local myHRP = getHRP(player.Character)
	local tHRP = getHRP(plr.Character)

	if myHRP and tHRP then
		if mode=="acercarse" then
			player.Character:MoveTo(tHRP.Position)
		elseif mode=="alejarse" then
			local dir=(myHRP.Position-tHRP.Position).Unit
			player.Character:MoveTo(myHRP.Position + dir*10)
		end
	end
end

--// 🧠 IA
local function detectMood(msg)
	msg=msg:lower()

	if msg:find("help") then return "guia"
	elseif msg:find("bug") then return "malo"
	elseif msg:find("no funciona") then return "muy_malo"
	elseif msg:find("wow") then return "dopamina"
	end

	return "normal"
end

local function canTalk()
	if cooldown then return false end
	cooldown=true
	task.delay(5,function() cooldown=false end)
	return true
end

local function sendChat(msg)
	game:GetService("ReplicatedStorage")
	.DefaultChatSystemChatEvents.SayMessageRequest
	:FireServer("[AI]: "..msg,"All")
end

--// ⏱️ DELAY HUMANO
local function getDelay(msg,mood)
	local base=math.random(1,2)
	local len=math.clamp(#msg/20,1,3)

	local extra=0
	if mood=="guia" then extra=2
	elseif mood=="muy_malo" then extra=1.5 end

	return base+len+extra
end

local function typing(delay)
	if math.random()<0.5 then sendChat("...") end
	task.wait(delay)
end

--// API + MEMORIA
local function askAI(context,plr)
	if API_KEY=="" then return end

	memory[plr]=memory[plr] or {}
	table.insert(memory[plr],context)

	local history=table.concat(memory[plr]," | ")

	local data={
		message="Jugador Roblox.\nPersonalidad:"..personality..
		"\nHistorial:"..history..
		"\nContexto:"..context..
		"\nResponde corto humano.",
		key=API_KEY
	}

	local s,r=pcall(function()
		return HttpService:PostAsync(API_URL,HttpService:JSONEncode(data))
	end)

	if s then
		return HttpService:JSONDecode(r).reply
	else
		return "xd no sé"
	end
end

--// 👀 MIRADA
local function isLookingAtMe(plr)
	local h1=plr.Character and plr.Character:FindFirstChild("Head")
	local h2=player.Character and player.Character:FindFirstChild("Head")
	if not h1 or not h2 then return false end

	local dir=(h2.Position-h1.Position).Unit
	local dot=dir:Dot(h1.CFrame.LookVector)
	local dist=(h2.Position-h1.Position).Magnitude

	return dot>0.8 and dist<20
end

--// 💬 COMANDOS
local following=false
local followTarget=nil

local function handleCommand(plr,msg)
	msg=msg:lower()

	if msg=="/ai follow" then
		following=true
		followTarget=plr
		sendChat("voy 😈")

	elseif msg=="/ai stop" then
		following=false
		sendChat("ok")

	elseif msg=="/ai ayuda" then
		sendChat("te ayudo bro")
	end
end

task.spawn(function()
	while true do
		task.wait(0.3)
		if following and followTarget and followTarget.Character then
			moveTo(followTarget,"acercarse")
		else
			following=false
		end
	end
end)

--// EVENTOS
local function onChat(plr,msg)
	if plr==player or not aiEnabled or not canTalk() then return end

	if msg:sub(1,3)=="/ai" then
		handleCommand(plr,msg)
		return
	end

	local mood=detectMood(msg)
	local emotion=getEmotion(mood)

	playEmotion(animations[emotion])

	local delay=getDelay(msg,mood)
	typing(delay)

	local reply=askAI(plr.Name.." dijo "..msg,plr.Name)

	if reply then
		sendChat(reply)

		if emotion=="happy" then moveTo(plr,"acercarse")
		elseif emotion=="angry" then lookAt(plr)
		elseif emotion=="sad" then moveTo(plr,"alejarse")
		end
	end
end

--// LOOP GLOBAL
task.spawn(function()
	while true do
		task.wait(2)
		if not aiEnabled then continue end

		for _,plr in pairs(Players:GetPlayers()) do
			if plr~=player then
				
				if isLookingAtMe(plr) and canTalk() then
					typing(getDelay("mirada","normal"))
					local r=askAI("me mira",plr.Name)
					if r then sendChat(r) end
				end

				local myHRP=getHRP(player.Character)
				local tHRP=getHRP(plr.Character)

				if myHRP and tHRP then
					local dist=(myHRP.Position-tHRP.Position).Magnitude
					if dist<10 and canTalk() then
						local r=askAI("cerca de "..plr.Name,plr.Name)
						if r then sendChat(r) end
					end
				end

			end
		end
	end
end)

--// RANDOM
task.spawn(function()
	while true do
		task.wait(math.random(20,40))
		if aiEnabled and canTalk() then
			local r=askAI("jugando normal","self")
			if r then sendChat(r) end
		end
	end
end)

--// CONECTAR
for _,plr in pairs(Players:GetPlayers()) do
	plr.Chatted:Connect(function(m)
		onChat(plr,m)
	end)
end

Players.PlayerAdded:Connect(function(plr)
	plr.Chatted:Connect(function(m)
		onChat(plr,m)
	end)
end)

Rayfield:Notify({
   Title="ERIK GOD 2.5",
   Content="TODO + OPTIMIZADO 😈🔥",
   Duration=6
})
