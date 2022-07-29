local Weapon = {}
Weapon.__index = Weapon

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Assets = ReplicatedStorage.Assets
local Modules = ReplicatedStorage.Modules
local Utils = ReplicatedStorage.Modules.Utils

local PlayerMovementInfo = require(Utils.PlayerMovementInfo)
local Math = require(Utils.Math)
local spring = require(ReplicatedStorage.Modules.Utils.spring)
local AnimationController = require(Modules.AnimationController)
local RigCreator = require(Utils.RigCreater)
local Cycles = require(Utils.Cycles)
local CrosshairModule = require(Modules.Crosshair)

CrosshairModule.CreateCrosshair()

--                           [ UTIL FUNCTIONS ]

local walkIndex = 1
local walkSounds = game.ReplicatedStorage.Assets.Audio.footstep.concrete:GetChildren()
print(walkSounds)
function playWalkSound()
	walkSounds[walkIndex]:Play()
	walkIndex += 1
	if walkIndex > #walkSounds then
		walkIndex = 1
	end
end

local clothIndex = 1
local ClothSounds = game.ReplicatedStorage.Assets.Audio.cloth_foliage:GetChildren()
function playClothSound()
	ClothSounds[clothIndex]:Play()
	clothIndex += 1
	if clothIndex > #ClothSounds then
		clothIndex = 1
	end
end

local function angles(x,y,z)
	return CFrame.Angles(math.rad(x),math.rad(y),math.rad(z))
end
local part = Instance.new("Part")
part.Parent = 	workspace
part.Anchored = true
part.CanCollide = false
part.Transparency = 0


--                           [ MAIN FUNCTIONS ]

function Weapon.new(WeaponModule : ModuleScript)
	local self = setmetatable({},Weapon)
	
	self.Weapon = require(WeaponModule)
	self.WeaponModel = self.Weapon.Model:Clone()
	self.Viewmodel = Assets.viewmodel:Clone()
	
	self.Viewmodel.Parent = workspace.Camera
	
	self.Status = {}
	self.Status.Equiped = false
	self.Status.Bullets = self.Weapon.Data.bullet.bullets_per_mag
	self.Status.Mags = self.Weapon.Data.bullet.mags
	
	self.Offsets = {}
	self.Offsets.EquipOffset = CFrame.new(Vector3.new(100,0,0))
	self.AimingOffset = Instance.new("CFrameValue")
	self.AimingOffset.Parent = self.Viewmodel
	
	self.Springs = {}
	self.Springs.Sway = spring.create()
	self.Springs.Walk = spring.create()
	self.Springs.WalkRot = spring.create()
	
	self.Viewmodel.FakeCamera.Transparency = 1
	self.Viewmodel.PrimaryPart.Transparency = 1
	RigCreator.rig(self.Viewmodel, self.WeaponModel) -- returns viewmodel but we dont need that again.
	
	--/ Cache all animations for future use without lag.
	self.AnimationController = AnimationController.new(self.Viewmodel)
	self.AnimationController:AddAnimation(self.Weapon.Data.animations.idle, "Idle")
	if self.Weapon.Data.animations.equip ~= 0 then
		self.AnimationController:AddAnimation(self.Weapon.Data.animations.equip, "Equip")
	end
	
	return self
end

function Weapon:Equip()
	if self.Status.Equiped then return end
	
	spawn(function()
		self.Offsets.EquipOffset = CFrame.new(Vector3.new(100,0,0))
		repeat wait() until self.AnimationController:GetAnimationLength("Equip") > 0
		self.Offsets.EquipOffset = CFrame.new(Vector3.new(0,0,0))
	end)
	playClothSound()
	wait(self.AnimationController:PlayAnimation("Equip"))
	self.Status.Equiped = true
	
	self.AnimationController:PlayAnimation("Idle")
end

function Weapon:Unequip()
	if not self.Status.Equiped then return end
	
	self.Offsets.EquipOffset = CFrame.new(Vector3.new(100,0,0))
	self:Aim(false)
	self.Status.Equiped = false
end

function Weapon:Aim(Aim)
	print(self.WeaponModel.AimPart.CFrame:ToObjectSpace(workspace.Camera.CFrame))
	
	local aimTweenInfo = TweenInfo.new(
		self.Weapon.Data.basic.aimTime,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut
	)
	if Aim then
		TweenService:Create(
			self.AimingOffset,
			aimTweenInfo,
			{Value = self.Weapon.Data.offsets.aiming}
		):Play()
	else
		TweenService:Create(
			self.AimingOffset,
			aimTweenInfo,
			{Value = CFrame.new(0,0,0)}
		):Play()
	end
end


--- UPDATE LOOP:::::
local walkedLastFrame = false
local lastFrameOffset = CFrame.new()	

function Weapon:Update(DeltaTime)
	self.Viewmodel.PrimaryPart.CFrame = workspace.Camera.CFrame * self.AimingOffset.Value * self.Offsets.EquipOffset  * self.Weapon.Data.offsets.idle
	
	local mouseDelta = uis:GetMouseDelta()
	self.Springs.Sway:shove(Vector3.new(mouseDelta.x / 500,mouseDelta.y / 500))  -- SWAY
	local sway = self.Springs.Sway:update(DeltaTime) -- Sway UPDATE
	
	local bobble = Math.GetBobbing(tick(), .05, 1)
	
	local speed = 15
	
	local moveVel = math.clamp(game.Players.LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude, 0, 1)
	local velocity = PlayerMovementInfo.GetMoveDirection() * moveVel * speed
	if PlayerMovementInfo.grounded() then
		self.Springs.Walk:shove(Cycles.getWalkCFrame(velocity.Magnitude)[1])
		self.Springs.WalkRot:shove(Cycles.getWalkCFrame(velocity.Magnitude)[2])
	end
	
	local Walk = self.Springs.Walk:update(DeltaTime)
	local WalkRot = self.Springs.WalkRot:update(DeltaTime)
	
	if velocity.Magnitude > 1 and PlayerMovementInfo.grounded() then
		if Walk.y < 0 then
			if not walkedLastFrame then
				walkedLastFrame = true
				playWalkSound()
			end
		else
			walkedLastFrame = false
		end
	end
	
	-- crosshair effect thing
	local beforeBobble = workspace.Camera.CFrame * lastFrameOffset:Inverse() * Math.Angles(bobble):Inverse()
	--e.CFrame = beforeBobble debug
	workspace.Camera.CFrame *= Math.Angles(bobble) -- custom angles thing ( just converts a vector3 to cframe.angles properly)
	CrosshairModule.Effect(beforeBobble) -- suppose to make it go to CFrame before the bobble.
	
	lastFrameOffset = Math.Angles(bobble)
	
	-------------------------
	self.WeaponModel.PrimaryPart.CFrame *= CFrame.Angles(0,sway.x,-sway.y) * CFrame.new(0,0, -sway.y) * CFrame.new(0,0, sway.x) * CFrame.new(Vector3.new(Walk.x, Walk.y, Walk.z)) * angles(WalkRot.x, WalkRot.y, WalkRot.z)
end

return Weapon
