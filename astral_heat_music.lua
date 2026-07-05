-- Astral Heat BGM Player
-- v0.0.5
-- Commissioned by SkeleJ64

local AstralHeatBGMPlayed = {}
local AstralHeatState = {}
local AstralMusicFade = {}
local PrevMusic = {}
local fadeStartVol = 0
local oppName = {}
local rival = {}
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

function f_AstralHeatBGM()
	if gameMode() == "demo" then return end -- to prevent game from crashing, we do not load the module during demo mode.
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
				if stateNo() == 3900 and moveHitVar('frame')
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
					for i = 1, 32 do
						local key = "rival" .. i .. "name"
						rival[pn] = start.f_getCharData(v.ref)[key]
						if rival[pn] and rival[pn] == oppName[pn] then
							local rMusic = "charparams.rival" .. i
							track = rMusic
							break
						end
					end

					playBgm({
						source = track,
						interrupt = true,
					})
			
				elseif var(20) ~= 1 then
					AstralHeatBGMPlayed[pn] = false
				end

				if var(20) == 1 and (not isAsserted('timerfreeze')) and roundState() == 2 and AstralHeatState[pn] == 1 then
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
