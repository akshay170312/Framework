local AimService = {}
local StatusChecker = require(script.Parent.StatusChecker)

function AimService:SetAiming(player, isAiming)
    local canAim, reason = StatusChecker:CanAim(player)
    if not canAim then
        return false, reason
    end
    StatusChecker:SetState(player, "IsAiming", isAiming)
    return true
end

function AimService:IsAiming(player)
    local state = StatusChecker:GetState(player)
    return state.IsAiming or false
end

return AimService
