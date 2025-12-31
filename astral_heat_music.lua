-- Astral Heat BGM Player
-- v0.0.4c
-- Commissioned by SkeleJ64

local AstralHeatBGMPlayed = {}

local Authors = {
	["OHMSBY"] = true,
	["Ichida"] = true,
	["Vinnie"] = true,
	["Resentone"] = true,
	["TornilloOxidado"] = true,
	["HakiKing"] = true,
	["ZolidSone"] = true,
	["JoeyS"] = true,
	["dionednd"] = true,
}


function f_AstralHeatBGM()
	-- if roundstate() ~= 2 then return end
	for side = 1, 2 do
		for _, v in pairs(start.p[side].t_selected) do
			if player(v.pn) then
				local author = authorname()
				if var(20) == 1 
				and not AstralHeatBGMPlayed[v.pn] 
				and playerno() == teamleader()
				and Authors[author] then
				
					AstralHeatBGMPlayed[v.pn] = true
			
					local oppName = ""
					if enemynear(0) then
						oppName=name()
					end
					player(v.pn)

					local track = "charparams.astral"

					for i = 1, 32 do
						local key = "rival" .. i .. "name"
						local rival = start.f_getCharData(v.ref)[key]
						
						if rival == oppName then
							local rMusic = "charparams.rival" .. i
							track = rMusic
							break
						end
					end

					if track == "" then track = "charparams.astral" end

					playBgm({
						source = track,
						interrupt = true,
					})
			
				elseif var(20) ~= 1 then
					AstralHeatBGMPlayed[v.pn] = false
				end
			end
		end
	end
end

hook.add("loop", "AstralHeatBGM", f_AstralHeatBGM)
