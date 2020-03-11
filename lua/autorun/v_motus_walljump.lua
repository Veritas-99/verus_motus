include("v_motus_cvars.lua")
include("v_motus_sounds.lua")

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
	hook.Add("PlayerPostThink", "v_motus_ppt_walljump", function(ply)
		if v_motus_walljump(ply) && ply.v_motus then
			local ppos = ply:GetPos()
			local eang = ply:EyeAngles()
			local frwdr = Vector(5, 0, 0)
			frwdr:Rotate(Angle(0, eang.yaw, 0))
			local ceilingTrace = util.QuickTrace(ppos, Vector(0, 0, 100), ply)
			local frontTrace = util.QuickTrace(ppos + Vector(0, 0, 20), frwdr * 3.5, ply)
			local leftTrace = util.QuickTrace(ppos + Vector(0, 0, 28), -eang:Right() * 23, ply)
			local rightTrace = util.QuickTrace(ppos + Vector(0, 0, 28), eang:Right() * 23, ply)

			if !ceilingTrace.Hit then
				local wallJumpCooldown = ply:AccountID() && ply:AccountID() .. "wjcd" || "wjcd"

				//Vertical segment
				if frontTrace.Hit && ply:KeyDown(IN_JUMP) && ply.v_motus_steps < v_motus_steps(ply) && !timer.Exists(wallJumpCooldown) then
					halfRotationWallJump(ply, wallJumpCooldown)
					//Horizontal segment
				elseif leftTrace.Hit && ply:KeyDown(IN_JUMP) && ply.v_motus_steps < v_motus_steps(ply) && !timer.Exists(wallJumpCooldown) then
					horizontalWallJump(ply, true, wallJumpCooldown)
				elseif rightTrace.Hit && ply:KeyDown(IN_JUMP) && ply.v_motus_steps < v_motus_steps(ply) && !timer.Exists(wallJumpCooldown) then
					horizontalWallJump(ply, false, wallJumpCooldown)
				end
			end
		end
	end)

	//Vertical Wall Jump
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

	//Horizontal Wall Jump
	function horizontalWallJump(ply, left, coolDown)
		local cVel = ply:GetVelocity()
		preVel = cVel:GetNormalized()
		preVel.z = 0

		if left then
			preVel:Rotate(Angle(0, -90, 0))
		else
			preVel:Rotate(Angle(0, 90, 0))
		end

		preVel.x = preVel.x - cVel:GetNormalized().x * 1.25
		preVel.y = preVel.y - cVel:GetNormalized().y * 1.25
		//
		local jumpForce = v_motus_step_force(ply) * 0.9091
		local vel = (preVel * (jumpForce * 0.6)) + Vector(0, 0, jumpForce - cVel.z)
		//
		ply:ViewPunch(Angle(-10, 0, 0))
		ply:EmitSound(stepsounds[math.random(#stepsounds)])
		//
		ply:SetVelocity(vel)
		//
		createWallJumpCoolDown(coolDown, ply)
	end

	function createWallJumpCoolDown(coolDown, ply)
		timer.Create(coolDown, 0.25, 1, function()
			ply.v_motus_steps = v_motus_stepsafterwj(ply)
		end)
	end
end