local Players = game:GetService("Players")

local StatusChecker = {}

local playerStates = {}

-- Retrieve the full state table for a player
function StatusChecker:GetState(player)
	if not playerStates[player.UserId] then
		playerStates[player.UserId] = {}
	end
	return playerStates[player.UserId]
end

-- Set a single state key
function StatusChecker:SetState(player, key, value)
	local state = self:GetState(player)
	state[key] = value
end

-- Clear all state for a player
function StatusChecker:ClearState(player)
	playerStates[player.UserId] = nil
end

-- Check if player can fire
function StatusChecker:CanFire(player)
	local state = self:GetState(player)
	if state.IsReloading then
		return false, "Reloading"
	end
	if (state.MagazineAmmo or 0) <= 0 then
		return false, "EmptyMagazine"
	end
	local now = os.clock()
	local fireRate = state.FireRate or 0.15
	if state.LastFireTime and (now - state.LastFireTime) < fireRate then
		return false, "FireRateCooldown"
	end
	return true
end

-- Check if player can reload
function StatusChecker:CanReload(player)
	local state = self:GetState(player)
	if state.IsReloading then
		return false, "AlreadyReloading"
	end
	local magSize = state.MagazineSize or 15
	if (state.MagazineAmmo or 0) >= magSize then
		return false, "MagazineFull"
	end
	if (state.ReserveAmmo or 0) <= 0 then
		return false, "NoReserveAmmo"
	end
	return true
end

-- Check if player can aim
function StatusChecker:CanAim(player)
	local state = self:GetState(player)
	if state.IsReloading then
		return false, "Reloading"
	end
	return true
end

-- Cleanup when player leaves
Players.PlayerRemoving:Connect(function(player)
	StatusChecker:ClearState(player)
end)

return StatusChecker