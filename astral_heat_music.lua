-- Astral Heat BGM Player
-- v0.0.4b
-- Commissioned by SkeleJ64

AstralHeatBGMPlayed = {}
AstralRivalTrack = {}

function f_AstralHeatBGM()
	if roundstate() ~= 2 then return end
	
	for p = 1, 8 do
		player(p)

		if var(20) == 1 
		and not AstralHeatBGMPlayed[p] 
		and playerno() == teamleader() then
			
			AstralHeatBGMPlayed[p] = true
			
			local oppName = ""
			enemynear(0)
			oppName=name()
			player(p)

			if not AstralRivalTrack[p] then
				for i = 1, 32 do
					local riv = main.t_selChars[start.c[p].selRef + 1]["rival" .. i .. "name"]
					 if riv ~= "" and riv == oppName then
						AstralRivalTrack[p] = "charparams.rival" .. i
						break
					end
				end
			end

			local track = AstralRivalTrack[p] or "charparams.astral"


			if track == "" then track = "charparams.astral" end

			playBgm({
				source = track,
				interrupt = true,
			})
			break
			
		elseif var(20) ~= 1 then
			AstralHeatBGMPlayed[p] = false
		end
	end
end

hook.add("loop", "AstralHeatBGM", f_AstralHeatBGM)
