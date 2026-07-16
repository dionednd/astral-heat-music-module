-- Astral Heat BGM Player
-- v0.0.7
-- Commissioned by SkeleJ64

local floor = math.floor
local min = math.min
local max = math.max

local gsub = string.gsub
local gmatch = string.gmatch

local STATE_IDLE = 0
local STATE_PLAYING = 1
local STATE_FADE_OUT = 2
local STATE_FADE_IN = 3

local ASTRAL_FIRST = 3900
local ASTRAL_LAST = 3999

local FADE_TIME = 50

local VALID_AUTHORS = {
	OHMSBY = true,
	Ichida = true,
	Vinnie = true,
	Resentone = true,
	TornilloOxidado = true,
	HakiKing = true,
	ZolidSone = true,
	JOHMSBY = true,
	dionednd = true,
	Rouuuu = true,
	OWO = true,
	RagingRowen = true,
}

local PlayerState = {}
local ActivePlayers = {}
local Initialized = false

local function getPlayerState(pn)

	local state = PlayerState[pn]

	if state then
		return state
	end

	state = {
		state = STATE_IDLE,
		played = false,
		fadeFrame = 0,
		fadeStart = 0,
		opponent = nil,
		prevMusic = {
			filename = nil,
			position = 0,
			volume = 100,
			loop = false,
			loopcount = 0,
			loopstart = 0,
			loopend = 0,
			freqmul = 1,
		},
	}

	PlayerState[pn] = state

	return state

end

local function parseRivalName(value)

	if type(value) ~= "string" then
		return {}
	end

	local names = {}

	if value:sub(1,1) == "{"
	and value:sub(-1) == "}" then
		local contents =
			value:sub(2,-2)
		for name in gmatch(contents, "[^/]+") do
			name = gsub(name,"^%s*(.-)%s*$","%1")
			names[name] = true
		end
	else
		value = gsub(value,"^%s*(.-)%s*$","%1")
		names[value] = true
	end

	return names

end

local function parseRivalData(chardata)

	local rivals = {
		lookup = {}
	}

	for key,value in pairs(chardata) do
		local num = key:match("^rival(%d+)name$")
		if num then
			local id = tonumber(num)
			local prefix = "rival"..num
			local names = parseRivalName(value)
			local rival = {
				id = id,
				names = names,
				track = "charparams.rival"..id,
				music = chardata[prefix..".music"],
				volume = chardata[prefix..".volume"],
				loop = chardata[prefix..".loop"],
				loopstart = chardata[prefix..".loopstart"],
				loopend = chardata[prefix..".loopend"],
				startposition = chardata[prefix..".startposition"],
				freqmul = chardata[prefix..".freqmul"],
				loopcount = chardata[prefix..".loopcount"],
			}

			rivals[id] = rival

			if type(names) == "table" then
				for name in pairs(names) do
					rivals.lookup[name] = rival
				end
			else
				rivals.lookup[names] = rival
			end
		end
	end

	return rivals

end

local function getPlayerNumber(side, member, charData)

	if teamMode() == "turns" then
		player(side)
		if charData.name == displayName()
		and charData.author == authorName() then
			return side
		end
		return nil
	end

	return 2 * (member - 1) + side

end

local function buildActivePlayers()

	ActivePlayers = {}

	for side = 1,2 do

		local selected =
			start.p[side].t_selected

		for member = 1,#selected do

			local character =
				selected[member]

			local pdata =
				start.f_getCharData(character.ref)

			local pn = getPlayerNumber(side, member, pdata)

			if pn then
				local playerData = {
					pn = pn,
					side = side,
					member = member,
					ref = character.ref,
					pdata = pdata,
					rivals = nil,
				}
				playerData.rivals = parseRivalData(pdata)
				ActivePlayers[#ActivePlayers+1] = playerData
			end
		end
	end
end

local function initializeMatch()

	if Initialized then
		return
	end
	buildActivePlayers()
	Initialized = true

end

local function resetMatch()

	Initialized = false
	ActivePlayers = {}
	PlayerState = {}

end

local function saveCurrentMusic(state)

	state.prevMusic.filename = bgmVar('filename')
	state.prevMusic.position = bgmVar('position')
	state.prevMusic.volume = bgmVar('volume')
	state.prevMusic.loop = bgmVar('loop')
	state.prevMusic.loopcount = bgmVar('loopcount')
	state.prevMusic.loopstart = bgmVar('loopstart')
	state.prevMusic.loopend = bgmVar('loopend')
	state.prevMusic.freqmul = bgmVar('freqmul')

end

local function restoreMusic(state)

	local music = state.prevMusic

	playBgm({
		bgm = music.filename,
		volume = 0,
		loop = music.loop,
		loopcount = music.loopcount,
		loopstart = music.loopstart,
		loopend = music.loopend,
		startposition = music.position,
		freqmul = music.freqmul,
	})

end

local function getAstralTrack(playerData,state)

	local track = "charparams.astral"
	local rivals = playerData.rivals

	if rivals then
		local rival = rivals.lookup[state.opponent]
		if rival then
			track = rival.track
		end
	end

	return track

end

local function startAstral(playerData,state,pn)

	saveCurrentMusic(state)
	enemyNear(0)
	state.opponent = name()

	player(pn)

	local track =
		getAstralTrack(
			playerData,
			state
		)

	local isDefault = track == "charparams.astral"

	if isDefault
	and not playerData.pdata["astral.music"] then
		state.state = STATE_IDLE
		return false
	end

	playBgm({
		source = track,
		interrupt = true,
	})

	state.state = STATE_PLAYING
	state.played = true

	return true

end

local function checkAstral(playerData)

	local pn = playerData.pn
	local state = getPlayerState(pn)

	if state.played then
		return
	end

	if roundState() ~= 2 then
		return
	end

	if not moveHitVar('frame') then
		return
	end

	local stateno = stateNo()

	if stateno < ASTRAL_FIRST
	or stateno > ASTRAL_LAST then
		return
	end

	local author = playerData.pdata.author

	if not VALID_AUTHORS[author] then
		return
	end

	player(pn)

	if playerNo() ~= teamLeader() then
		return
	end

	startAstral(playerData,state,pn)

end

local BGMVolumeUpdate = {
	volume = 0,
	interrupt = false,
}

local function beginFadeOut(state)

	state.state = STATE_FADE_OUT
	state.fadeFrame = fightTime()
	state.fadeStart = bgmVar('volume')

end

local function updateFadeOut(state)

	local elapsed = fightTime() - state.fadeFrame
	local progress = min(elapsed / FADE_TIME, 1)
	local volume = floor(state.fadeStart * max(0, 1 - progress))

	BGMVolumeUpdate.volume = volume

	playBgm(BGMVolumeUpdate)

	if volume <= 0 then
		restoreMusic(state)

		state.state = STATE_FADE_IN
		state.fadeFrame = fightTime()
		state.fadeStart = state.prevMusic.volume
	end
end

local function updateFadeIn(state)

	local elapsed = fightTime() - state.fadeFrame
	local progress = min(elapsed / FADE_TIME, 1)
	local volume = floor(state.fadeStart * progress)

	BGMVolumeUpdate.volume = volume

	playBgm(BGMVolumeUpdate)

	if progress >= 1 then
		state.state = STATE_IDLE
		state.fadeFrame = 0
		state.fadeStart = 0
	end
end

local function updatePlayer(playerData)

	local pn = playerData.pn

	player(pn)

	local state = getPlayerState(pn)

	if roundState() <= 1 then
		state.state = STATE_IDLE
		state.played = false
	end

	if state.state == STATE_IDLE then
		checkAstral(playerData)
	end

	if state.state == STATE_PLAYING then
		local stateno = stateNo()

		if var(20) == 1
		and (stateno < ASTRAL_FIRST or stateno > ASTRAL_LAST)
		and roundState() == 2 then
			beginFadeOut(state)
		end
	end

	if state.state == STATE_FADE_OUT then
		updateFadeOut(state)
	elseif state.state == STATE_FADE_IN then
		updateFadeIn(state)
	end
end

local PreviousFightTime = -1

local function f_AstralHeatBGM()

	local time = fightTime()

	if time == 1 and PreviousFightTime ~= 1 then
		resetMatch()
		initializeMatch()
	end
	PreviousFightTime = time

	if not Initialized then
		return
	end

	for i = 1,#ActivePlayers do
		updatePlayer(ActivePlayers[i])
	end
end

hook.add("loop", "AstralHeatBGM", f_AstralHeatBGM)
