local AnimationController = {}
AnimationController.__index = AnimationController

function AnimationController.new(	viewmodel:Model	 )
	local self = setmetatable({},AnimationController)
	
	self.Viewmodel = viewmodel
	self.Humanoid = viewmodel:FindFirstChild("Humanoid") or viewmodel:WaitForChild("Humanoid")
	self.Animator = self.Humanoid:FindFirstChildOfClass("Animator")
	
	self.CacheFolder = Instance.new("Folder")
	self.CacheFolder.Parent = self.Viewmodel
	
	self.Cache = {}
	self.TimeScale = 1
	
	return self
end

function AnimationController:AddAnimation(	AnimationId:number	,  Name:string	)
	local Animation = Instance.new("Animation")
	Animation.AnimationId = "rbxassetid://"..AnimationId
	Animation.Name = Name
	Animation.Parent = self.CacheFolder
	self.Cache[Name] = self.Animator:LoadAnimation(Animation)
	
	print("[AnimationController] Cached: "..Name)
end

function AnimationController:PlayAnimation(	   Name:string	 )
	if self.Cache[Name] then
		self.Cache[Name]:AdjustSpeed(self.Cache[Name].Length * self.TimeScale)
		self.Cache[Name]:Play()
		return self.Cache[Name].Length
	else
		warn("[AnimationController] Error: Animation "..Name.." is not cached!")
	end
end


--/ not usefull but still here just cause
function AnimationController:GetAnimationLength(Name:AnimationTrack)
	return self.Cache[Name].Length
end

function AnimationController:GetCache()
	return self.Cache
end

function AnimationController:GetCacheFolder()
	return self.CacheFolder
end

function AnimationController:SetTimeScale(	muliplier:number )
	self.TimeScale = muliplier
end

function AnimationController:GetTimeScale()
	return self.TimeScale
end

return AnimationController
