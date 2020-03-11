include("v_motus_cvars.lua")
include("v_motus_sounds.lua")

if SERVER then
	hook.Add("PlayerPostThink", "v_motus_ppt_falldamage", function(ply)
		if v_motus_falldamage(ply) then
			local tr = util.QuickTrace(ply:GetPos(), Vector(0, 0, -10000), ply)

			if tr.Entity then
				local newRelativeSpeed = ply:GetVelocity().z - tr.Entity:GetVelocity().z
				ply.v_motus_relativeSpeed = newRelativeSpeed != 0 && newRelativeSpeed || relativeSpeed
			end
		end
	end)

	hook.Add("GetFallDamage", "v_motus_gfd", function(ply, speed)
		local mult
		local returnVal

		if speed > 530 then
			if speed > 900 then
				mult = 0.85
			elseif speed > 800 then
				mult = 0.8
			elseif speed > 700 then
				mult = 0.5
			elseif speed > 650 then
				mult = 0.25
			else
				mult = 0
			end

			if v_motus_falldamage(ply) then
				local fallDamage = (-1 * ply.v_motus_relativeSpeed / v_motus_falldamagedivider(ply))

				if ply.v_motus_roll then
					returnVal = fallDamage * mult
				else
					returnVal = fallDamage
				end
			else
				if ply.v_motus_roll then
					returnVal = 10 * mult
				else
					returnVal = 10
				end
			end
		end

		if !ply.v_motus_roll && v_motus_voices() then
			if v_motus_gender(ply) == "male" then
				ply:EmitSound(painSoundM[math.random(#painSoundM)], 50, 100, 1)
			elseif v_motus_gender(ply) == "female" then
				ply:EmitSound(painSoundF[math.random(#painSoundF)], 50, 100, 1)
			end
		end

		return returnVal
	end)
end