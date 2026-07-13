-- Demo Mode Fix for some of my lua modules
-- allows subtitles to work during demo mode

local original_selectChar = selectChar

function selectChar(side, ch, pal, override)
	original_selectChar(side, ch, pal, override)
	
	if main.f_demoStart_running then
		start.p = start.p or {}

		start.p[side] = start.p[side] or {}
		start.p[side].t_selected = {
			{
				ref = ch,
				pal = pal,
				pn = side,
				cursor = {0, 0},
				loading = true,
				selected = true,
				maps = {}
			}
		}
	end
end

local original_f_demoStart = main.f_demoStart
function main.f_demoStart()
	main.f_demoStart_running = true
	original_f_demoStart()
	main.f_demoStart_running = false
end