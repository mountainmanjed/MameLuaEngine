--Cps2 color test
cpu = manager:machine().devices[":maincpu"]
mem = cpu.spaces["program"]

gui = manager:machine().screens[":screen"]

ramstart = 0x90C000--Ramstart for SFA3

function display()
--Globals
mame = 0x0000
size = 2
colorform = cpscolor
length = 15 --how many colors you want in each row (0=1color)
rows = 3 -- How many rows 0 = 1 row also so 3 = 4 rows
xpos = 16 -- X offset

adr = ramstart + (mame * size) - size

--gui.text(40,8,"Address: " .. hex(adr+ size))

for height = 0,rows,1 do
gui:draw_text(xpos+(length+2)*8 ,4 + height*8,"ADR: " .. hexval(adr+size))

for row1 = 0,length,1 do
	adr = adr + size
	gui:draw_box(xpos+row1*8, 4+height*8, xpos+8+row1*8, 12+height*8, colorform(adr),0x00000000)
	end
end	
end

function cpscolor(adr)
	local red = band(mem:read_u16(adr),0x0F00)/0x100
	local green = band(mem:read_u16(adr),0x00F0)/0x10
	local blue = band(mem:read_u16(adr),0x000F)

	color = 0xFF000000 +((red*17)*0x10000)+((green*17)*0x100)+(blue*17)
	return color
end



function band(a,b)
	return a&b
end

function hexval(val)
	val = string.format("%X",val)
	return val
end

emu.sethook(display, "frame")
