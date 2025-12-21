-- Astral Heat BGM Player for OHMSBY Style Characters
-- v 0.0.3a
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
			playBgm({
				source = "charparams.astral",
				interrupt = true,
			})
		elseif var(20) ~= 1 then
			AstralHeatBGMPlayed[p] = false
		end
	end
end
hook.add("loop", "AstralHeatBGM", f_AstralHeatBGM)
