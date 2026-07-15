-- Astral Heat BGM Player
-- v0.0.6
-- Commissioned by SkeleJ64

local AstralHeatBGMPlayed = {}
local AstralHeatState = {}
local AstralMusicFade = {}
local PrevMusic = {}
local fadeStartVol = 0
local oppName = {}
local Authors = {
	["OHMSBY"] = true,
	["Ichida"] = true,
	["Vinnie"] = true,
	["Resentone"] = true,
	["TornilloOxidado"] = true,
	["HakiKing"] = true,
	["ZolidSone"] = true,
	["JOHMSBY"] = true,
	["dionednd"] = true,
	["Rouuuu"] = true,
	["OWO"] = true,
	["RagingRowen"] = true,
}

local dur = 0

local function parseRivalName(value)
	if type(value) ~= "string" then
		return value
	end

	if value:sub(1, 1) ~= "{" or value:sub(-1) ~= "}" then
		return value
	end

	local tbl = {}
	local contents = value:sub(2, -2)

	for name in string.gmatch(contents, "[^/]+") do
		name = string.gsub(name, "^%s+", "")
		name = string.gsub(name, "%s+$", "")
		table.insert(tbl, name)
	end

	return tbl
end

local function parseRivalData(chardata)
	rivals = {}
	rivals.lookup = {}

	for key, value in pairs(chardata) do
		local num = key:match("^rival(%d+)name$")
		if num then
			local id = tonumber(num)
			local prefix = "rival" .. num

			local rivalNames = parseRivalName(value)

			rivals[id] = {
				name = rivalNames,
				music = chardata[prefix .. ".music"],
				volume = chardata[prefix .. ".volume"],
				loop = chardata[prefix .. ".loop"],
				loopstart = chardata[prefix .. ".loopstart"],
				loopend = chardata[prefix .. ".loopend"],
				startposition = chardata[prefix .. ".startposition"],
				freqmul = chardata[prefix .. ".freqmul"],
				loopcount = chardata[prefix .. ".loopcount"],
			}

			if type(rivalNames) == "table" then
				for i = 1, #rivalNames do
					rivals.lookup[rivalNames[i]] = id
				end
			else
				rivals.lookup[rivalNames] = id
			end
		end
	end

	return rivals
end

local function characterExists(list, name)
	for i = 1, #list do
		if list[i] == name then
			return true
		end
	end
	return false
end

function f_AstralHeatBGM()

	if fightTime() == 1 then
		local existingCharacters = {}
		for side = 1, 2 do
			for member, v in pairs(start.p[side].t_selected) do
				if teamMode() == "turns" then
					player(side)
					if start.f_getCharData(v.ref).name == displayName() and start.f_getCharData(v.ref).author == authorName() then
						pn = side
					else
						pn = 69420 -- for the memes
					end
				else
					pn = 2 * (member - 1) + side
				end

				if player(pn) then
					existingCharacters[name()] = true
					local pdata = start.f_getCharData(v.ref)

					if start.p[side].t_selected[member].rivals == nil then
						start.p[side].t_selected[member].rivals = parseRivalData(pdata)
					end
				end
			end
		end
		for side = 1, 2 do
			for member, v in pairs(start.p[side].t_selected) do
				local rivals = start.p[side].t_selected[member].rivals

				if rivals then
					for id, rival in pairs(rivals) do
						if id ~= "lookup" then

							if type(rival.name) == "table" then
								local filteredNames = {}

								for i = 1, #rival.name do
									local rivalName = rival.name[i]

									if existingCharacters[rivalName] then
										table.insert(filteredNames, rivalName)
									end
								end

								rival.name = filteredNames

								if #filteredNames == 0 then
									rivals[id] = nil
								else
									for i = 1, #filteredNames do
										rivals.lookup[filteredNames[i]] = id
									end
								end

							elseif type(rival.name) == "string" then
								if existingCharacters[rival.name] then
									rivals.lookup[rival.name] = id
								else
									rivals[id] = nil
								end
							end
						end
					end
				end
			end
		end
	end

	for side = 1, 2 do
		for member, v in pairs(start.p[side].t_selected) do
			
			if teamMode() == "turns" then
				player(side)
				if start.f_getCharData(v.ref).name == displayName() and start.f_getCharData(v.ref).author == authorName() then
					pn = side
				else
					pn = 69420 -- for the memes
				end
			else
				pn = 2 * (member - 1) + side
			end

			if player(pn) then

				if roundState() <= 1 then
					AstralHeatState[pn] = 0
					AstralMusicFade[pn] = 0
				end

				local author = authorName()
				if stateNo() >= 3900 and stateNo() <= 3999 and moveHitVar('frame')
				and not AstralHeatBGMPlayed[pn] 
				and playerNo() == teamLeader()
				and Authors[author] 
				and roundState() == 2 then
					AstralHeatState[pn] = 1
					AstralHeatBGMPlayed[pn] = true

					PrevMusic["filename"] = bgmVar('filename')
					PrevMusic["position"] = bgmVar('position')
					PrevMusic["loop"] = bgmVar('loop')
					PrevMusic["loopstart"] = bgmVar('loopstart')
					PrevMusic["loopend"] = bgmVar('loopend')
					PrevMusic["loopcount"] = bgmVar('loop')
					PrevMusic["volume"] = bgmVar('volume')
					PrevMusic["freqmul"] = bgmVar('freqmul')

					enemyNear(0)
					oppName[pn]=name()
					player(pn)

					local track = "charparams.astral"

					local rivals = start.p[side].t_selected[member].rivals

					local targetOpponent = oppName[pn]

					if rivals and rivals.lookup[targetOpponent] then
						local rivalID = rivals.lookup[targetOpponent]
						track = "charparams.rival" .. rivalID
					end

					if (track == "charparams.astral" and start.f_getCharData(v.ref)['astral.music']) or track ~= "charparams.astral" then
						playBgm({
							source = track,
							interrupt = true,
						})
					else
						AstralHeatState[pn] = 0
					end
			
				elseif var(20) ~= 1 then
					AstralHeatBGMPlayed[pn] = false
				end

				if var(20) == 1 and (stateNo() < 3900 or stateNo() > 3999) and roundState() == 2 and AstralHeatState[pn] == 1 then
					dur = 50

					AstralHeatState[pn] = 2
					AstralMusicFade[pn] = fightTime()
					fadeStartVol = bgmVar('volume')
					printConsole(fadeStartVol)
				end
				if AstralHeatState[pn] == 2 then
					local t = math.min(dur, fightTime() - AstralMusicFade[pn])
					local fadeVol = math.floor(fadeStartVol * math.max(0.0, 1.0 - t / dur))
					playBgm({volume = fadeVol, interrupt = false})
					-- updateVolume()
					printConsole(math.floor(fadeVol))
					if fadeVol == 0 then
						playBgm({
							bgm = PrevMusic["filename"],
							volume = fadeVol,
							loop = PrevMusic["loop"],
							loopcount = PrevMusic["loopcount"],
							loopstart = PrevMusic["loopstart"],
							loopend = PrevMusic["loopend"],
							startposition = PrevMusic["position"],
							freqmul = PrevMusic["freqmul"],
						}) -- replay previous music and fade it in
						AstralHeatState[pn] = 3
						AstralMusicFade[pn] = fightTime()
						fadeStartVol = PrevMusic["volume"]
						printConsole(fadeStartVol)
					end
				end
				if AstralHeatState[pn] == 3 then
					local t = math.min(dur, fightTime() - AstralMusicFade[pn])
					local fadeVol = math.floor(fadeStartVol * math.min(1.0, t / dur))
					playBgm({volume = fadeVol, interrupt = false})
					-- updateVolume()
					printConsole(fadeVol)
					if t >= dur then
						AstralHeatState[pn] = 0
						AstralMusicFade[pn] = nil
						fadeStartVol = nil
					end
				end
			end
		end
	end
end

hook.add("loop", "AstralHeatBGM", f_AstralHeatBGM)
