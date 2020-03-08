//ConVar accessibility
v_motus_serverside = "v_motus_serverside"

function serverside()
	return cvarGetBool(v_motus_serverside)
end

v_motus_roll_l = "v_motus_roll_l"
v_motus_roll_g = "v_motus_roll_g"

function v_motus_roll(ply)
	if serverside() then
		return cvarGetBool(v_motus_roll_g)
	else
		return cvarGetBool(v_motus_roll_l, ply)
	end
end

v_motus_falldamage_l = "v_motus_falldamage_l"
v_motus_falldamage_g = "v_motus_falldamage_g"

function v_motus_falldamage(ply)
	if serverside() then
		return cvarGetBool(v_motus_falldamage_g)
	else
		return cvarGetBool(v_motus_falldamage_l, ply)
	end
end

v_motus_falldamagedivider_l = "v_motus_falldamagedivider_l"
v_motus_falldamagedivider_g = "v_motus_falldamagedivider_g"

function v_motus_falldamagedivider(ply)
	if serverside() then
		return cvarGetFloat(v_motus_falldamagedivider_g)
	else
		return cvarGetFloat(v_motus_falldamagedivider_l, ply)
	end
end

v_motus_steps_l = "v_motus_steps_l"
v_motus_steps_g = "v_motus_steps_g"

function v_motus_steps(ply)
	if serverside() then
		return cvarGetInt(v_motus_steps_g)
	else
		return cvarGetInt(v_motus_steps_l, ply)
	end
end

v_motus_step_force_l = "v_motus_step_force_l"
v_motus_step_force_g = "v_motus_step_force_g"

function v_motus_step_force(ply)
	if serverside() then
		return cvarGetInt(v_motus_step_force_g)
	else
		return cvarGetInt(v_motus_step_force_l, ply)
	end
end

//ConCommands & ConVars
concommand.Add("+v_motus", function(ply)
	ply.v_motus = true
end)

concommand.Add("-v_motus", function(ply)
	ply.v_motus = false
end)

CreateConVar(v_motus_serverside, 1)
//
CreateClientConVar(v_motus_roll_l, 1, true, true)
CreateConVar(v_motus_roll_g, 1)
//
CreateClientConVar(v_motus_falldamage_l, 1, true, true)
CreateConVar(v_motus_falldamage_g, 1)
//
CreateClientConVar(v_motus_falldamagedivider_l, 8.75, true, true)
CreateConVar(v_motus_falldamagedivider_g, 8.75)
//
CreateClientConVar(v_motus_steps_l, 3, true, true)
CreateConVar(v_motus_steps_g, 3)
//
CreateClientConVar(v_motus_step_force_l, 275, true, true)
CreateConVar(v_motus_step_force_g, 275)

//ConVar utilities
function cvarGetBool(var, ply)
	if ply != nil then
		local val = ply:GetInfoNum(var, -1)

		if val == 1 then
			return true
		elseif val == 0 then
			return false
		else
			return nil
		end
	else
		if ConVarExists(var) then
			return GetConVar(var):GetBool()
		else
			return nil
		end
	end
end

function cvarGetFloat(var, ply)
	if ply != nil then
		local val = ply:GetInfoNum(var, -1)

		return val
	else
		if ConVarExists(var) then
			return GetConVar(var):GetFloat()
		else
			return nil
		end
	end
end

function cvarGetInt(var, ply)
	if ply != nil then
		local val = ply:GetInfoNum(var, -1)

		return val
	else
		if ConVarExists(var) then
			return GetConVar(var):GetInt()
		else
			return nil
		end
	end
end