local DamageResolver = {}

function DamageResolver.Compute(gunConfig, context)
	local baseDamage = gunConfig.Damage or 25
	local damage = baseDamage

	-- Headshot multiplier
	if context.isHeadshot then
		damage = damage * (gunConfig.HeadshotMultiplier or 2)
	end

	-- Distance falloff (linear range)
	if context.distance and gunConfig.Range then
		local falloffStart = gunConfig.Range * 0.6
		if context.distance > falloffStart then
			local falloffFactor = 1 - ((context.distance - falloffStart) / (gunConfig.Range - falloffStart))
			falloffFactor = math.clamp(falloffFactor, 0.3, 1)
			damage = damage * falloffFactor
		end
	end

	-- Target damage reduction attribute
	if context.damageReduction then
		damage = damage * (1 - math.clamp(context.damageReduction, 0, 0.9))
	end

	return math.floor(damage + 0.5)
end

return DamageResolver