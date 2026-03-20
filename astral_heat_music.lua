-- Astral Heat BGM Player
-- v0.0.4h
-- Commissioned by SkeleJ64

local AstralHeatBGMPlayed = {}
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

				local author = authorName()
				if var(20) == 1 
				and not AstralHeatBGMPlayed[pn] 
				and playerNo() == teamLeader()
				and Authors[author] 
				and roundState() == 2 then
				
					AstralHeatBGMPlayed[pn] = true

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
			end
		end
	end
end

hook.add("loop", "AstralHeatBGM", f_AstralHeatBGM)
