//TTT Statistics by mka0207.

AddCSLuaFile( 'autorun/client/cl_statistics.lua' )
AddCSLuaFile( 'vgui/pstats_ttt.lua' )
AddCSLuaFile( 'vgui/dexroundedframe.lua' )
AddCSLuaFile( 'vgui/dexroundedpanel.lua' )

print("Loaded TTT Statistics by mka0207")

resource.AddFile( "materials/icon16/stat_innocent.png" )
resource.AddFile( "materials/icon16/stat_innocent_selection.png" )
resource.AddFile( "materials/icon16/stat_traitor.png" )
resource.AddFile( "materials/icon16/stat_traitor_selection.png" )

local function LoadStatistics( pl, steamid, uniqueid )
	if !IsValid( pl ) || !pl:IsPlayer() then return end
	
	pl:SetNWInt( "traitor_wins", pl:GetPData( "traitor_wins", 0 ) )
	pl:SetNWInt( "traitor_decaps", pl:GetPData( "traitor_decaps", 0 ) )
	pl:SetNWInt( "traitor_deaths", pl:GetPData( "traitor_deaths", 0 ) )
	pl:SetNWInt( "innocent_wins", pl:GetPData( "innocent_wins", 0 ) )
	pl:SetNWInt( "innocent_deaths", pl:GetPData( "innocent_deaths", 0 ) )
	--pl:SetNWInt( "teammate_killed", pl:GetPData( "teammate_killed", 0 ) )
	pl:SetNWInt( "traitor_killed", pl:GetPData( "traitor_killed", 0 ) )
	pl:SetNWInt( "innocent_killed", pl:GetPData( "innocent_killed", 0 ) )
	pl:SetNWInt( "detective_killed", pl:GetPData( "detective_killed", 0 ) )
end
hook.Add( 'PlayerAuthed', 'FWKZT.PlayerAuthedStats.TTT', LoadStatistics )

local function SaveStatistics( pl )
	if !IsValid( pl ) || !pl:IsPlayer() then return end

	pl:SetPData( "traitor_wins", pl:GetNWInt( "traitor_wins" ) )
	pl:SetPData( "traitor_decaps", pl:GetNWInt( "traitor_decaps" ) )
	pl:SetPData( "traitor_deaths", pl:GetNWInt( "traitor_deaths" ) )
	pl:SetPData( "innocent_wins", pl:GetNWInt( "innocent_wins" ) )
	pl:SetPData( "innocent_deaths", pl:GetNWInt( "innocent_deaths" ) )
	--pl:SetPData( "teammate_killed", pl:GetNWInt( "teammate_killed" ) )
	pl:SetPData( "traitor_killed", pl:GetNWInt( "traitor_killed" ) )
	pl:SetPData( "innocent_killed", pl:GetNWInt( "innocent_killed" ) )
	pl:SetPData( "detective_killed", pl:GetNWInt( "detective_killed" ) )
end
hook.Add( 'PlayerDisconnected', 'FWKZT.PlayerDisconnectedStats.TTT', SaveStatistics )

local function TTT_TTTEndRound( result )
	for _, pl in pairs( player.GetAll() ) do
		if !IsValid(pl) then continue end
		if pl:IsSpec() then continue end
	
		if result == WIN_TRAITOR then
			if pl:IsRole( ROLE_TRAITOR ) then
				pl:SetNWInt( "traitor_wins", pl:GetNWInt( "traitor_wins" ) + 1 )
				pl:SetPData( "traitor_wins", pl:GetNWInt( "traitor_wins" ) )
				--print(pl:Nick().." Has "..pl:GetNWInt( "traitor_wins" ).." Traitor Wins!")
			end
		elseif result == WIN_INNOCENT then
			if ( pl:IsRole( ROLE_INNOCENT ) || pl:IsRole( ROLE_DETECTIVE ) ) then
				pl:SetNWInt( "innocent_wins", pl:GetNWInt( "innocent_wins" ) + 1 )
				pl:SetPData( "innocent_wins", pl:GetNWInt( "innocent_wins" ) )
				--print(pl:Nick().." Has "..pl:GetNWInt( "innocent_wins" ).." Innocent Wins!")
			end	
		end
	end	
end

local function TTT_DoPlayerDeath( pl, attacker, dmginfo)
	if !( IsValid(pl) && IsValid(attacker) ) then return end

	local decap = pl:LastHitGroup() == HITGROUP_HEAD
	if decap then
		if pl:IsRole( ROLE_TRAITOR ) then
			attacker:SetNWInt( "traitor_decaps", attacker:GetNWInt( "traitor_decaps" ) + 1 )
			attacker:SetPData( "traitor_decaps", attacker:GetNWInt( "traitor_decaps" ) )
			--print(attacker:Nick().." Has "..attacker:GetNWInt( "traitor_decaps" ).." Traitor Decapitations!")
			pl:SetNWInt( "traitor_deaths", pl:GetNWInt( "traitor_deaths" ) + 1 )
			pl:SetPData( "traitor_deaths", pl:GetNWInt( "traitor_deaths" ) )
			--print(pl:Nick().." Has "..pl:GetNWInt( "traitor_deaths" ).." Traitor Deaths!")
		end	
	else
		if pl:IsRole( ROLE_TRAITOR ) then
			attacker:SetNWInt( "traitor_killed", attacker:GetNWInt( "traitor_killed" ) + 1 )
			attacker:SetPData( "traitor_killed", attacker:GetNWInt( "traitor_killed" ) )
			--print(attacker:Nick().." Has "..attacker:GetNWInt( "traitor_killed" ).." Traitor Kills!")
			pl:SetNWInt( "traitor_deaths", pl:GetNWInt( "traitor_deaths" ) + 1 )
			pl:SetPData( "traitor_deaths", pl:GetNWInt( "traitor_deaths" ) )
			--print(pl:Nick().." Has "..pl:GetNWInt( "traitor_deaths" ).." Traitor Deaths!")
		elseif pl:IsRole( ROLE_DETECTIVE ) then
			attacker:SetNWInt( "detective_killed", attacker:GetNWInt( "detective_killed" ) + 1 )
            attacker:SetPData( "detective_killed", attacker:GetNWInt( "detective_killed" ) )
			--print(attacker:Nick().." Has "..attacker:GetNWInt( "detective_killed" ).." Detective Kills!")
			pl:SetNWInt( "innocent_deaths", pl:GetNWInt( "innocent_deaths" ) + 1 )
            pl:SetPData( "innocent_deaths", pl:GetNWInt( "innocent_deaths" ) )
			--print(pl:Nick().." Has "..pl:GetNWInt( "innocent_deaths" ).." Innocent Deaths!")
		elseif pl:IsRole( ROLE_INNOCENT ) then	
			attacker:SetNWInt( "innocent_killed", attacker:GetNWInt( "innocent_killed" ) + 1 )
            attacker:SetPData( "innocent_killed", attacker:GetNWInt( "innocent_killed" ) )
            --print(attacker:Nick().." Has "..attacker:GetNWInt( "innocent_killed" ).." Innocent Kills!")
            pl:SetNWInt( "innocent_deaths", pl:GetNWInt( "innocent_deaths" ) + 1 )
			pl:SetPData( "innocent_deaths", pl:GetNWInt( "innocent_deaths" ) )
            --print(pl:Nick().." Has "..pl:GetNWInt( "innocent_deaths" ).." Innocent Deaths!")
		end	
	end
end

local function TTT_Command( pl, text, teamchat )
	if ! IsValid(pl) then return end
	
		if ( text == "!stats" ) then
			pl:SendLua( "MakepSelectionTTT()" )
			for k, v in pairs(player.GetAll()) do v:ChatPrint( "" .. pl:Nick() .. " is checking out TTT Statistics! (Type !stats)" ) end
		end
	
	return
end	

local function AddHooks()
	if GAMEMODE_NAME == 'terrortown' then
		hook.Add( 'PlayerSay', 'FWKZT.ChatCommandStats.TTT', TTT_Command )
		hook.Add( 'TTTEndRound', 'FWKZT.TTTEndRoundStats.TTT', TTT_TTTEndRound )
		hook.Add( 'DoPlayerDeath', 'FWKZT.DoPlayerDeathStats.TTT', TTT_DoPlayerDeath )
	end
end
hook.Add( "Initialize", "FWKZT.TTTStatistics.AddHooks", AddHooks )