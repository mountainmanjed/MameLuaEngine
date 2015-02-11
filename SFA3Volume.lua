cpu = manager:machine().devices[":audiocpu"]
mem = cpu.spaces["program"]

gui = manager:machine().screens[":screen"]
function main()
track = 0xF700 - 0x50

for t = 0,15,1 do
	track = track + 0x50
	local volume = mem:read_u8(track + 0x19)

	gui:draw_box(0+t*8,0,8+t*8,0+volume*8,0xFF000000 + volume*10000,0)
	
	
	end
end

function hexval(val)
	val = string.format("%X",val)
	return val
end

emu.sethook(main, "frame")
