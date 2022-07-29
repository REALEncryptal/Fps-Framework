local module = {}

function module.newData()
	local data		 = {}
	
	data.attachments = {}
	data.damage 	 = {}
	data.modes 		 = {}
	data.animations  = {}	 
	data.bullet 	 = {}
	data.basic	     = {}
	data.offsets     = {}
	
	-----------------------------------/ attachments
	data.attachments.optics      = {}
	data.attachments.barrrel     = {}
	data.attachments.underbarrel = {}
	data.attachments.other       = {}
	data.attachments.mods        = {}
	----------------/ attachments subs
	data.attachments.optics.whitelisted 	 = {}
	data.attachments.optics.blacklisted 	 = {}
	
	data.attachments.barrrel.whitelisted 	 = {}
	data.attachments.barrrel.blacklisted 	 = {}
	
	data.attachments.underbarrel.whitelisted = {}
	data.attachments.underbarrel.blacklisted = {}
	
	data.attachments.other.whitelisted 	 	 = {}
	data.attachments.other.blacklisted 		 = {}
	
	data.attachments.mods.whitelisted 		 = {}
	data.attachments.mods.blacklisted 		 = {}
	
	-----------------------------------/ damage
	data.damage.areas 	= {}
	data.damage.dropoff = {}
	----------------/ damage subs
	data.damage.base = 0
	
	data.damage.areas.head  = 10
	data.damage.areas.torso = 0
	data.damage.areas.arms  = -4
	data.damage.areas.legs  = -7
	
	data.damage.dropoff.maxDamageRange = 0 -- how far away the hit can be without changing damage
	data.damage.dropoff.minDamage = 0
	
	-----------------------------------/ modes
	data.modes.semi  = false
	data.modes.auto  = false
	data.modes.burst = false
	
	-----------------------------------/ animations
	data.animations.equip   = 0 --OPTIONAL TODO: Create tweened equip animation if no equip animation.
	data.animations.idle 	= 0
	data.animations.shoot 	= 0
	data.animations.reload 	= 0
	data.animations.inspect = 0 --TODO: Create inspect animation check. If it is empty: play default anim
	
	-----------------------------------/ bullet
	data.bullet.hipSpread 	= 0
	data.bullet.adsSpread	= 0
	data.bullet.proneSpread = 0
	
	data.bullet.rpm 			= 0
	data.bullet.bullets_per_mag = 0
	data.bullet.mags 			= 0
	
	-----------------------------------/ basic
	data.basic.cost		  = 0
	data.basic.unlockRank = 0
	
	data.basic.aimTime 	  = 0
	
	-----------------------------------/ offsets
	data.offsets.idle = CFrame.new()
	data.offsets.aiming = CFrame.new()
	
	return data
end

return module
