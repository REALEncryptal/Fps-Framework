local Math = {}

function Math.GetBobbing(deltaTime, multiplier, speed) -- 10 .25
	local bob1 = multiplier * math.sin(deltaTime * speed/2) 
	local bob2 = multiplier * math.sin(deltaTime * (speed))
		
	return Vector3.new(bob1, bob2, 0)
end

function Math.Angles(angle)
	return CFrame.Angles(
		math.rad(angle.X),
		math.rad(angle.Y),
		math.rad(angle.Z)
	)
end

function Math.Vector3Clamp(value, min, max)
	return Vector3.new(
		math.clamp(value.X, min, max),
		math.clamp(value.Y, min, max),
		math.clamp(value.Z, min, max)
	)
end

return Math
