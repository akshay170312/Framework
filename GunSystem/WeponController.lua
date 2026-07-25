local WeaponService = require(game:GetService("ServerScriptService"):WaitForChild("WeaponService"))
local Remote = Instance.new("RemoteEvent")
Remote.Name = "WeaponRemote"
Remote.Parent = game:GetService("ReplicatedStorage")

Remote.OnServerEvent:Connect(function(player, action, ...)
    if action == "Fire" then
        WeaponService:Fire(player, ...)
    elseif action == "Reload" then
        WeaponService:Reload(player, ...)
    end
end)