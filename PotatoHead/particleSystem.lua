ParticleSystem = {}
ParticleSystem_mt = {__index = ParticleSystem}

function ParticleSystem:create(x, y, image, ps_lifetime, min_lifetime, max_lifetime, emission_rate, buffer)
	if buffer == nil then
		buffer = 32
	end
	local new_ps = {}
	new_ps.ps = love.graphics.newParticleSystem( image, buffer )
	new_ps.ps:setParticleLifetime(min_lifetime, max_lifetime)
	new_ps.ps:setEmissionRate(emission_rate)
	new_ps.ps:setPosition(x, y)
	new_ps.ps:setEmitterLifetime(0.5)
	setmetatable(new_ps, ParticleSystem_mt)
	new_ps.lifetime = ps_lifetime
	Level:add_ps(new_ps)
	return new_ps
end

DoubleJumpPS = {__index = ParticleSystem}
DoubleJumpPS_mt = {__index = DoubleJumpPS}
DoubleJumpPS.image = love.graphics.newImage( sprite_path .. "smoke.png" )

function DoubleJumpPS:create(x, y)
	local new_ps = ParticleSystem:create(x, y, DoubleJumpPS.image, 2, 0.5, 0.6, 100, 3)
	new_ps.ps:setAreaSpread("uniform", 10, 0.5)
	new_ps.ps:setSpeed(90, 100)
	new_ps.ps:setRadialAcceleration(100, 100)
	new_ps.ps:setDirection(1.57079632679)
	--new_ps.ps:setLinearAcceleration(-2, 40, 2, 50)
	new_ps.ps:setSizes(1, 0.8, 0.5, 0.2)
	new_ps.ps:setColors(255, 255, 255, 255, 255, 255, 255, 0)
	setmetatable(new_ps, DoubleJumpPS_mt)
end
