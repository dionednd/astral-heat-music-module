-- Astral Heat BGM Player for OHMSBY Style Characters
-- v 0.0.1
-- Commissioned by SkeleJ64

AstralHeatBGMPlayed = false

function f_AstralHeatBGM()
	if roundstate() == 2 and var(20) == 1 and not AstralHeatBGMPlayed then
		AstralHeatBGMPlayed = true
		playBgm({
			source = "charparams.astral",
			interrupt = true,
		})
	else
		AstralHeatBGMPlayed = false
	end
end

hook.add("loop", "AstralHeatBGM", f_AstralHeatBGM)