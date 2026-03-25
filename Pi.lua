--// LOAD RAYFIELD
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// SERVICIOS
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local player = players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

--// VARIABLES
local ESP = {
    Players = false,
    Monsters = false,
    Scrap = false,
    Artifact = false
}

local espTable = {}
local spawnPos = root.Position

--// UI
local Window = Rayfield:CreateWindow({
    Name = "Into The Abyss HUB",
    LoadingTitle = "Loading...",
    ConfigurationSaving = {Enabled = false}
})

local Tab = Window:CreateTab("ESP / TP", 4483362458)

--// FUNCIONES ESP
local function createESP(obj, color, label)
    if espTable[obj] then return end

    local box = Drawing.new("Square")
    box.Color = color
    box.Thickness = 2
    box.Filled = false
    box.Visible = false

    local text = Drawing.new("Text")
    text.Color = color
    text.Size = 14
    text.Center = true
    text.Outline = true
    text.Visible = false

    espTable[obj] = {box = box, text = text, label = label}
end

local function removeESP(obj)
    if espTable[obj] then
        for _,v in pairs(espTable[obj]) do
            v:Remove()
        end
        espTable[obj] = nil
    end
end

local function getPos(obj)
    if obj:IsA("Player") then
        if obj.Character and obj.Character:FindFirstChild("HumanoidRootPart") then
            return obj.Character.HumanoidRootPart.Position
        end
    elseif obj:IsA("Model") and obj.PrimaryPart then
        return obj.PrimaryPart.Position
    elseif obj:IsA("BasePart") then
        return obj.Position
    end
end

--// SCAN
local function scan()
    for _,v in pairs(workspace:GetDescendants()) do
        local name = string.lower(v.Name)

        -- Players
        if ESP.Players and v:IsA("Player") and v ~= player then
            createESP(v, Color3.fromRGB(255,0,0), "PLAYER")
        end

        -- Monsters
        if ESP.Monsters and v:IsA("Model") and v:FindFirstChild("Humanoid") and not players:GetPlayerFromCharacter(v) then
            createESP(v, Color3.fromRGB(0,255,0), "MONSTER")
        end

        -- Scrap
        if ESP.Scrap and (string.find(name,"scrap") or string.find(name,"metal")) then
            createESP(v, Color3.fromRGB(255,255,0), "SCRAP")
        end

        -- Artifact
        if ESP.Artifact and (string.find(name,"artifact") or string.find(name,"artefact")) then
            createESP(v, Color3.fromRGB(170,0,255), "ARTIFACT")
        end
    end
end

--// LOOP
runService.RenderStepped:Connect(function()
    scan()

    for obj, esp in pairs(espTable) do
        local pos3D = getPos(obj)

        if pos3D then
            local pos, onScreen = camera:WorldToViewportPoint(pos3D)

            if onScreen then
                local distance = math.floor((pos3D - camera.CFrame.Position).Magnitude)
                local size = 800 / distance

                esp.box.Size = Vector2.new(size, size)
                esp.box.Position = Vector2.new(pos.X - size/2, pos.Y - size/2)
                esp.box.Visible = true

                esp.text.Position = Vector2.new(pos.X, pos.Y - size)
                esp.text.Text = esp.label.." ["..distance.."]"
                esp.text.Visible = true
            else
                esp.box.Visible = false
                esp.text.Visible = false
            end
        end
    end
end)

--// TOGGLES
Tab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Callback = function(v) ESP.Players = v end
})

Tab:CreateToggle({
    Name = "ESP Monsters",
    CurrentValue = false,
    Callback = function(v) ESP.Monsters = v end
})

Tab:CreateToggle({
    Name = "ESP Scrap",
    CurrentValue = false,
    Callback = function(v) ESP.Scrap = v end
})

Tab:CreateToggle({
    Name = "ESP Artifact",
    CurrentValue = false,
    Callback = function(v) ESP.Artifact = v end
})

--// TELEPORTS
Tab:CreateButton({
    Name = "Teleport to Artifact",
    Callback = function()
        local closest, dist = nil, math.huge

        for obj,_ in pairs(espTable) do
            if string.find(string.lower(obj.Name),"artifact") then
                local pos = getPos(obj)
                if pos then
                    local d = (root.Position - pos).Magnitude
                    if d < dist then
                        dist = d
                        closest = pos
                    end
                end
            end
        end

        if closest then
            root.CFrame = CFrame.new(closest + Vector3.new(0,3,0))
        end
    end
})

Tab:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        root.CFrame = CFrame.new(spawnPos + Vector3.new(0,3,0))
    end
})
