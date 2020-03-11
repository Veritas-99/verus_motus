include("v_motus_cvars.lua")
include("v_motus_sounds.lua")

if SERVER then
	util.AddNetworkString("v_motus_turn")

	hook.Add("OnPlayerHitGround", "v_motus_ophg_wallrun", function(ply, inWater, onFloater, speed)
		ply.v_motus_steps = v_motus_steps(ply)
	end)

	hook.Add("PlayerPostThink", "v_motus_ppt_wallrun", function(ply)
		if v_motus_steps(ply) > 0 && ply.v_motus then
			local plyv = ply:GetVelocity()
			local ppos = ply:GetPos()
			local eang = ply:EyeAngles()
			local frwdr = Vector(5, 0, 0)
			frwdr:Rotate(Angle(0, eang.yaw, 0))
			local ceilingTrace = util.QuickTrace(ppos, Vector(0, 0, 100), ply)
			local frontTrace = util.QuickTrace(ppos + Vector(0, 0, 20), frwdr * 3.5, ply)
			local leftTrace = util.QuickTrace(ppos + Vector(0, 0, 28), -eang:Right() * 23, ply)
			local rightTrace = util.QuickTrace(ppos + Vector(0, 0, 28), eang:Right() * 23, ply)

			if !ceilingTrace.Hit then
				local wallRunCooldown = ply:AccountID() && ply:AccountID() .. "wrcd" || "wrcd"

				//Vertical segment
				if frontTrace.Hit then
					if ply:KeyDown(IN_FORWARD) && !ply:KeyDown(IN_JUMP) && !timer.Exists(wallRunCooldown) && ply.v_motus_steps > 0 then
						verticalWallRun(ply, plyv, wallRunCooldown)
					end
					//Horizontal segment
				elseif leftTrace.Hit then
					if ply:KeyDown(IN_FORWARD) && ply:KeyDown(IN_MOVELEFT) && !ply:KeyDown(IN_JUMP) && !timer.Exists(wallRunCooldown) && ply.v_motus_steps > 0 then
						horizontalWallRun(ply, plyv, wallRunCooldown)
					end
				elseif rightTrace.Hit then
					if ply:KeyDown(IN_FORWARD) && ply:KeyDown(IN_MOVERIGHT) && !ply:KeyDown(IN_JUMP) && !timer.Exists(wallRunCooldown) && ply.v_motus_steps > 0 then
						horizontalWallRun(ply, plyv, wallRunCooldown)
					end
				end
			end
		end
	end)

	//Vertical Wall Run
	function verticalWallRun(ply, vel, coolDown)
		ply.v_motus_steps = ply.v_motus_steps - 1
		//
		ply:ViewPunch(Angle(-15, 0, 0))
		ply:EmitSound(stepsounds[math.random(#stepsounds)])
		//
		ply:SetVelocity(Vector(0 - vel.x * 0.75, 0 - vel.y * 0.75, v_motus_step_force(ply) - (vel.z > -200 && vel.z || 0)))
		//
		createWallRunCoolDown(coolDown)
	end

	//Horizontal Wall Run
	function horizontalWallRun(ply, vel, coolDown)
		ply.v_motus_steps = ply.v_motus_steps - 1
		//
		ply:ViewPunch(Angle(-15, 0, 0))
		ply:EmitSound(stepsounds[math.random(#stepsounds)])
		//
		ply:SetVelocity(Vector(0, 0, (v_motus_step_force(ply) * 0.9091) - (vel.z > -200 && vel.z || 0)))
		//
		createWallRunCoolDown(coolDown)
	end

	function createWallRunCoolDown(coolDown)
		timer.Create(coolDown, 0.3, 1, function() end)
	end
end