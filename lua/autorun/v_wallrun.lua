include("cvars.lua")
include("sounds.lua")

if CLIENT then
	//180 degree turn
	local v_motus_turnData

	net.Receive("v_motus_turn", function()
		v_motus_turnData = net.ReadTable()
	end)

	hook.Add("CalcView", "v_motus_cv_turn", function(ply, src, ang, fov)
		if !v_motus_turnData then return end
		if !v_motus_turnData["turn"] then return end
		local view = GAMEMODE:CalcView(ply, src, ang, fov)
		v_motus_turnData["yaw"] = math.Approach(v_motus_turnData["yaw"], v_motus_turnData["ang"].y + v_motus_turnData["deg"], FrameTime() * 1000)

		if v_motus_turnData["yaw"] == v_motus_turnData["ang"].y + v_motus_turnData["deg"] then
			v_motus_turnData["turn"] = false

			return
		end

		local eang = ply:EyeAngles()
		ply:SetEyeAngles(Angle(eang.x, v_motus_turnData["yaw"], eang.z))

		return view
	end)
end

if SERVER then
	util.AddNetworkString("v_motus_turn")

	hook.Add("OnPlayerHitGround", "v_motus_ophg_wallrun", function(ply, inWater, onFloater, speed)
		ply.v_motus_steps = v_motus_steps(ply)
	end)

	hook.Add("PlayerPostThink", "v_motus_ppt_wallrun", function(ply)
		//Enter parkour mode
		if ply.v_motus then
			local epos = ply:GetPos()
			local eang = ply:EyeAngles()
			local frwdr = Vector(5, 0, 0)
			frwdr:Rotate(Angle(0, eang.yaw, 0))
			local plyv = ply:GetVelocity()
			local frontTrace = util.QuickTrace(epos + Vector(0, 0, 20), frwdr * 5, ply)
			local ceilingTrace = util.QuickTrace(epos, Vector(0, 0, 100), ply)

			//Vertical segment
			if !ceilingTrace.Hit && frontTrace.Hit then
				local wallRunCooldown = ply:AccountID() && ply:AccountID() .. "wrcd" || "wrcd"
				local wallJumpCooldown = ply:AccountID() && ply:AccountID() .. "wrjp" || "wrjp"

				if ply:KeyDown(IN_FORWARD) && !ply:KeyDown(IN_JUMP) && !timer.Exists(wallRunCooldown) && ply.v_motus_steps > 0 then
					verticalWallRun(ply, plyv, wallRunCooldown)
				elseif ply:KeyDown(IN_JUMP) && ply.v_motus_steps < v_motus_steps(ply) && !timer.Exists(wallJumpCooldown) then
					halfRotationWallJump(ply, wallJumpCooldown)
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
		ply:SetVelocity(Vector(0 - vel.x * 0.75, 0 - vel.y * 0.75, v_motus_step_force(ply) - (vel.z >= 0 && vel.z || 0)))
		//
		createWallRunCoolDown(coolDown)
	end

	function createWallRunCoolDown(coolDown)
		timer.Create(coolDown, 0.3, 1, function() end)
	end

	//Vertial Wall Jump
	function halfRotationWallJump(ply, coolDown)
		local preVel = -ply:EyeAngles():Forward()
		preVel.z = 0
		//
		local jumpForce = v_motus_step_force(ply) * 0.9091
		local vel = ((preVel * jumpForce) + Vector(0, 0, jumpForce - ply:GetVelocity().z))
		//
		ply:ViewPunch(Angle(-10, 0, 0))
		ply:EmitSound(stepsounds[math.random(#stepsounds)])
		//
		ply:SetVelocity(vel)
		//
		local directions = {185, -185}
		local eang = ply:EyeAngles()

		local v_motus_turnData = {
			deg = directions[math.random(#directions)],
			ang = eang,
			yaw = eang.y,
			turn = true
		}

		net.Start("v_motus_turn")
		net.WriteTable(v_motus_turnData)
		net.Send(ply)
		//
		createWallJumpCoolDown(coolDown, ply)
	end

	function createWallJumpCoolDown(coolDown, ply)
		timer.Create(coolDown, 0.25, 1, function()
			ply.v_motus_steps = v_motus_steps(ply)
		end)
	end
end