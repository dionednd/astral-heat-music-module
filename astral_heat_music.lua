-- Astral Heat BGM Player
-- v0.0.4a
-- Commissioned by SkeleJ64

AstralHeatBGMPlayed = {}

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

			local track = "charparams.astral"
			for i = 1, 9 do
				local key = "rival" .. i .. "name"
				local riv = main.t_selChars[start.c[p].selRef + 1][key]
				if riv ~= "" and riv == oppName then
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
			AstralHeatBGMPlayed[p] = false
		end
	end
end

hook.add("loop", "AstralHeatBGM", f_AstralHeatBGM)
