local Raycaster = {}
Raycaster.__index = Raycaster

function Raycaster.new(Part, Distance, Filter, FilterType)
	local self = setmetatable({},Raycaster)
	
	
	self.Part = Part
	self.Distance = Distance or 1
	self.Filter = Filter or {}
	self.FilterType = FilterType or Enum.RaycastFilterType.Whitelist
	
	return self
end

function Raycaster:Cast(Distance)
	Distance = Distance or self.Distance
	
	-- Filtering:
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = self.Whitelist
	raycastParams.FilterType = self.FilterType
	
	-- Raycast:
	local raycastResult = workspace:Raycast(
		self.Part.Position,
		self.Part.CFrame.LookVector * Distance, -- where to cast to
		raycastParams
	)
	
	return raycastResult	
end

return Raycaster
