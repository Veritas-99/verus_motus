include("v_motus_cvars.lua")
include("v_motus_sounds.lua")
include("v_motus_walljump.lua")

if SERVER then
	hook.Add("PlayerPostThink", "v_motus_ppt_grab", function(ply)
		local grabCooldown = ply:AccountID() && ply:AccountID() .. "gcd" || "gcd"

		if ply.v_motus && ply:KeyDown(IN_USE) && CanGrab(ply) && !ply.v_motus_grabbing then
			ply.v_motus_grabbing = true
			ply:EmitSound(Sound(gearSound[math.random(#gearSound)], 50))
			ply:ViewPunch(Angle(15, 0, 0))
			ply:SetLocalVelocity(Vector(0, 0, 0))
			ply:SetMoveType(MOVETYPE_NONE)
		elseif ply.v_motus_grabbing && ply:KeyDown(IN_FORWARD) && ply:KeyDown(IN_JUMP) && !timer.Exists(grabCooldown) then
			ply:EmitSound(Sound(gearSound[math.random(#gearSound)], 50))
			ply:ViewPunch(Angle(15, 0, 0))
			ply:SetMoveType(MOVETYPE_WALK)
			ply:SetVelocity(Vector(0, 0, 325))
			//
			createGrabCoolDown(grabCooldown, ply)
		elseif ply.v_motus_grabbing && ply:KeyDown(IN_JUMP) && !timer.Exists(grabCooldown) then
			local wallJumpCooldown = ply:AccountID() && ply:AccountID() .. "wjcd" || "wjcd"
			ply:ViewPunch(Angle(15, 0, 0))
			ply:SetMoveType(MOVETYPE_WALK)
			halfRotationWallJump(ply, wallJumpCooldown)
			ply.v_motus_grabbing = nil
		elseif ply.v_motus_grabbing && ply:KeyDown(IN_DUCK) && !timer.Exists(grabCooldown) then
			ply:SetMoveType(MOVETYPE_WALK)
			ply.v_motus_grabbing = nil
		end
	end)

	function CanGrab(player)
		local trace = {}
		trace.start = player:GetShootPos() + Vector(0, 0, 15)
		trace.endpos = trace.start + player:GetAimVector() * 30
		trace.filter = player
		local trHi = util.TraceLine(trace)
		//
		trace = {}
		trace.start = player:GetShootPos()
		trace.endpos = trace.start + player:GetAimVector() * 30
		trace.filter = player
		local trLo = util.TraceLine(trace)

		if trLo && trHi && trLo.Hit && !trHi.Hit then
			return true
		else
			return false
		end
	end

	function createGrabCoolDown(coolDown, ply)
		timer.Create(coolDown, 1, 1, function()
			ply.v_motus_grabbing = nil
		end)
	end
end