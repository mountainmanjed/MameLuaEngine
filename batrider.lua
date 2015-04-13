cpu = manager:machine().devices[":maincpu"]
mem = cpu.spaces["program"]
gui = manager:machine().screens[":screen"]

--Color format is T =transparency, R= red, G= Green, B = blue
--so 0xTTRRGGBB
--Hurt box
hurtboxfill = 0x60FF0000
hurtboxoutline = 0xFFFFFF00
--Collection Boxes
colectboxfill = 0xA0FF0000
colectboutline = 0xFF00FFFF
unk = 0xFFFFFFFF


h = hurtboxoutline
c = colectboutline
u = unk
--even if it isn't the actual ID 
colors = {
--  0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f
	h,u,u,u,c,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u
}



function main()
camx = band(mem:read_i16(0x2034E2),0xFF80)/0x80

--Sprites
--spradr 0x20869A, 72 offset
adr = 0x20869A - 0x72
for a = 0,0x60,1 do
adr = adr + 0x72
local active = band(mem:read_u8(adr),0x80)/0x80
local y = band(mem:read_i16(adr + 0x2A),0xFF80)/0x80
local x = band(mem:read_i16(adr + 0x2C),0xFF80)/0x80
local boxpnt = mem:read_u32(adr + 0x1A)

local hp = mem:read_u16(adr + 0x50)

if active == 1 then
boxes = 0
	--LEAVE THIS COMMENTED OUT OR MAME WILL CRASH during gameplay
	--gui:draw_text(y-8,x-camx,hp)
	repeat boxes = boxes + 1
	until mem:read_i16(boxpnt + (boxes * 8)) == 0x00
	
	
	for nbox = 0,boxes-1,1 do
		colbox(boxpnt+(nbox*8),y,x-camx)
		
	end
	
	drawaxis(y,x - camx,2,0xFFFFFFFF)
end
end


--Players
pladr =  0x204062 - 0x172

for pl = 0,1,1 do

pladr = pladr + 0x172
local active = band(mem:read_u8(pladr),0x80)/0x80
local y = band(mem:read_i16(pladr + 0x4A),0xFF80)/0x80
local x = band(mem:read_i16(pladr + 0x4C),0xFF80)/0x80

local boxpnt = mem:read_u32(pladr + 0x0A)
local cell = mem:read_u16(pladr + 0x14)
local frame = mem:read_u16(pladr + 0x16)
local cellp2 = cell + frame
local boxdata1 = mem:read_u16(boxpnt + cell)
local boxdata2 = mem:read_u16(boxdata1 + boxpnt)
local boxdata3 = boxdata2 + boxdata1 + boxpnt

if active == 1 then
boxes = 0

	gui:draw_text(8,8+(pl*8),hexval(boxdata3))

	repeat boxes = boxes + 1
	until mem:read_i16(boxdata3 + (boxes * 8)) == 0x00

	
	for nbox = 0,boxes-1,1 do
		colbox(boxdata3+(nbox*8),y,x-camx)
		
	end
	
	drawaxis(y,x - camx,2,0xFFFFFFFF)
	end
end
end

function drawaxis(x,y,l,color)

gui:draw_line(x+l,y,x-l,y,color)
gui:draw_line(x,y+l,x,y-l,color)

end

function colbox(adr,x,y)
id = band(mem:read_i16(adr + 0x06),0x003F)

mathx = (mem:read_i16(adr))
mathy = (mem:read_i16(adr + 0x04))

basex = mem:read_i16(adr + 0x02)
basey = mem:read_i16(adr + 0x06) - id


x1 = (basex-mathx)/0x80
y1 = (basey-mathy)/0x80

x2 = (basex+mathx)/0x80
y2 = (basey+mathy)/0x80

if mathx ~= 0 then
gui:draw_box(x+x1,y+y1,x+x2,y+y2,0,colors[id+1])
end

--[[
gui:draw_text(8,24,"Address: " .. hexval(adr))
gui:draw_text(128,24,"X1: " .. x1 .. ", " .. x+x1)
gui:draw_text(128,32,"Y1: " .. y1 .. ", " .. y+y1)
gui:draw_text(128,40,"X2: " .. x2 .. ", " .. x+x2)
gui:draw_text(128,48,"Y2: " .. y2 .. ", " .. y+y2)
--]]
end

function cordinate(x)
local val1 = band(mem:read_u16(x),0x003F)
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
