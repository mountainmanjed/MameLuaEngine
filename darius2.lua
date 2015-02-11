cpu = manager:machine().devices[":maincpu"]
mem = cpu.spaces["program"]

--Screens
guils = manager:machine().screens[":lscreen"]
guims = manager:machine().screens[":mscreen"]
guirs = manager:machine().screens[":rscreen"]


function main()
local padr = 0x2400D0
	local py = mem:read_i16(padr + 0x10)
	local px = mem:read_i16(padr + 0x14)
guils:draw_text(16,16,"X,Y: " .. px .. ", " ..  py)
guils:draw_text(16,24,"X,Y: " .. hexval(px) .. ", " ..  hexval(py))
	
drawaxis(px,py,8,0xFFFFFFFF)
end


function drawaxis(x,y,axis,color)

--Left screen
guils:draw_line(x+axis,y,x-axis,y,color)
guils:draw_line(x,y+axis,x,y-axis,color)

--Middle screen
guims:draw_line(x+axis-288,y,x-axis-288,y,color)
guims:draw_line(x-288,y+axis,x-288,y-axis,color)

--Right Screen
guirs:draw_line(x+axis-576,y,x-axis-576,y,color)
guirs:draw_line(x-576,y+axis,x-576,y-axis,color)

end

function hexval(val)
	val = string.format("%X",val)
	return val
end

emu.sethook(main, "frame")
