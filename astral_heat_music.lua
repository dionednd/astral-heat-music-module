-- Astral Heat BGM Player for OHMSBY Style Characters
-- v 0.0.2
-- Commissioned by SkeleJ64

AstralHeatBGMPlayed = false

function f_AstralHeatBGM()
	player(teamleader()) -- makes the module also work for tag team mode
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
