include("v_motus_cvars.lua")
include("v_motus_sounds.lua")

if CLIENT then
	local v_motus_rollData

	net.Receive("v_motus_roll", function()
		v_motus_rollData = net.ReadTable()
	end)

	hook.Add("CalcView", "v_motus_cv_roll", function(ply, src, ang, fov)
		if !v_motus_rollData then return end
		if !v_motus_rollData["roll"] then return end
		local view = GAMEMODE:CalcView(ply, src, ang, fov)
		v_motus_rollData["pitch"] = math.Approach(v_motus_rollData["pitch"], v_motus_rollData["deg"], FrameTime() * 700)

		if v_motus_rollData["pitch"] == v_motus_rollData["deg"] then
			v_motus_rollData["roll"] = false
		end

		view.angles.p = v_motus_rollData["pitch"]

		return view
	end)

	hook.Add("CalcViewModelView", "v_motus_cvmv_roll", function(wep, vm, pos_, ang_, pos, ang)
		if !v_motus_rollData then return end
		if !v_motus_rollData["roll"] then return end
		ang.p = v_motus_rollData["pitch"]

		return pos, ang
	end)
end

if SERVER then
	util.AddNetworkString("v_motus_roll")

	hook.Add("OnPlayerHitGround", "v_mouts_ophg_roll", function(ply, inWater, onFloater, speed)
		if v_motus_roll(ply) then
			if (!inWater || onFloater) && ply:KeyDown(IN_DUCK) && speed >= 530 then
				ply.v_motus_roll = true
				ply:EmitSound(gearSound[math.random(#gearSound)], 50, 100, 1)
				local eangp = math.Round(ply:EyeAngles().pitch)

				v_motus_rollData = {
					deg = eangp,
					pitch = eangp - 360,
					roll = true
				}

				net.Start("v_motus_roll")
				net.WriteTable(v_motus_rollData)
				net.Send(ply)
			else
				ply.v_motus_roll = false
			end

			timer.Simple(0.1, function()
				ply.v_motus_roll = nil
			end)
		end
	end)
end