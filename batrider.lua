cpu = manager:machine().devices[":maincpu"]
mem = cpu.spaces["program"]
gui = manager:machine().screens[":screen"]

--Color format is T =transparency, R= red, G= Green, B = blue
--so 0xTTRRGGBB
--Hurt box
hurtboxfill = 0xC0FF0000
hurtboxoutline = 0xFFFFFF00
--Collection Boxes
colectboxfill = 0x00
colectboutline = 0xFF00FFFF

function main()
camx = band(mem:read_i16(0x2034E2),0xFF80)/0x80

--[[
Ingame Sprite Start 0x20869A, 72 offset
for a = 0,0x60,1 do
adr = adr + 0x72
x = adr + 0x2A
]]

--Player 1 memory 0x204062
adr = 0x204062
local active = band(mem:read_u8(adr),0x80)/0x80
local y = band(mem:read_i16(adr + 0x4A),0xFF80)/0x80
local x = cordinate(adr + 0x4C)

local boxpnt = mem:read_u32(adr + 0x0A)
local cell = mem:read_u16(adr + 0x14)
local cellp2 = cell + mem:read_u16(adr + 0x16)
local boxdata1 = mem:read_u16(boxpnt + cell)
local boxdata2 = mem:read_u16(boxdata1 + boxpnt)
local boxdata3 = boxdata2 + boxdata1 + boxpnt

if active == 1 then
gui:draw_text(8,16,"X,Y: " .. x .. ", ".. y)
gui:draw_text(8,24,"BoxADR: " .. hexval(boxdata3))

--[[
If bit 4 is flagged probably a collection box
dividing by 0x80 won't work
so either do a check before drawing and take it away
or figure out how to keep the sign with a bit and
]]
	colbox(boxdata3,y,x-camx,hurtboxfill,hurtboxoutline)
	--colbox(boxdata3+8,y,x-camx,0,0xFFFF0000)
	--colbox(boxdata3+16,y,x-camx,0,0xFFFF0000)
	--colbox(boxdata3+24,y,x-camx,0,0xFFFF0000)


	drawaxis(y,x - camx,4,0xFFFFFFFF)
	end

end

function drawaxis(x,y,l,color)

gui:draw_line(x+l,y,x-l,y,color)
gui:draw_line(x,y+l,x,y-l,color)

end

function colbox(adr,x,y,fill,out)
refy = mem:read_i16(adr)
refx = mem:read_i16(adr + 0x04)

y1 = (mem:read_i16(adr+2)-refy)/0x80
x1 = (mem:read_i16(adr + 0x06)-refx)/0x80

y2 = (mem:read_i16(adr+2)+refy)/0x80
x2 = (mem:read_i16(adr + 0x06)+refx)/0x80

gui:draw_box(x+y1,y+x1,x+y2,y+x2,fill,out)
--[[
gui:draw_text(180,48,"Pair 1: " .. y1 .. ", " .. x1)
gui:draw_text(180,64,"Pair 2: " .. y2 .. ", " .. x2)
]]
end

function cordinate(x)
local val1 = band(mem:read_u16(x),0x007F)
local val2 = mem:read_i16(x)
local val3 = (val2 - val1)/0x80

return val3

end

function hexval(val)
	val = string.format("%X",val)
	return val
end

function band(a,b)
	return a&b
end

emu.sethook(main, "frame")
