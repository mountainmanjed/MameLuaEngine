cpu = manager:machine().devices[":maincpu"]
mem = cpu.spaces["program"]
gui = manager:machine().screens[":screen"]

--Color format is T =transparency, R= red, G= Green, B = blue
--so 0xTTRRGGBB
--Hurt box
hurtboxoutline = 0xFFFFFF00
colectboutline = 0xFF00FFFF
unk = 0xFFFFFFFF
attack = 0xFFFF77FF


a = attack
h = hurtboxoutline
c = colectboutline
u = unk
--even if it isn't the actual ID 
plcolors = {
--  0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f
	h,u,u,u,c,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u
}

encolors = {
--  0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f
	h,u,u,u,c,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u
}

pjcolors = {
--  0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f
	a,u,u,u,c,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,
	u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u
}

function main()
camx = band(mem:read_i16(0x2034E2),0xFF80)/0x80
baserank = mem:read_i16(0x20F9CE)

--Player1 projectiles
prjadr = 0x20478A - 0x4e
for proj = 0,0x40,1 do
prjadr = prjadr  + 0x4E
other_sprites(prjadr,pjcolors)
end

enpjadr = 0x20B15A - 0x40
for enproj = 0,0x30,1 do
enpjadr = enpjadr  + 0x40
other_sprites(enpjadr,pjcolors)
end


--spradr 0x20869A, 72 offset
adr = 0x20869A - 0x72
for a = 0,0x5F,1 do
adr = adr + 0x72
other_sprites(adr,encolors)
end


--Players
pladr =  0x204062 - 0x172

for pl = 0,1,1 do

pladr = pladr + 0x172
local active = band(mem:read_u8(pladr),0x80)/0x80
local boxactive = band(mem:read_u8(pladr),0x02)/0x02
local y = band(mem:read_i16(pladr + 0x4A),0xFF80)/0x80
local x = band(mem:read_i16(pladr + 0x4C),0xFF80)/0x80
local xa = 0
local boxpnt = mem:read_u32(pladr + 0x0A)
local cell = mem:read_u16(pladr + 0x14)
local frame = mem:read_u16(pladr + 0x16)
local cellp2 = cell + frame
local boxdata1 = mem:read_u16(boxpnt + cell)
local boxdata2 = mem:read_u16(boxdata1 + boxpnt + frame)
local boxdata3 = boxdata2 + boxdata1 + boxpnt

if active == 1 then
boxes = 0

	repeat boxes = boxes + 1
	until mem:read_i16(boxdata3 + (boxes * 8)) == 0x00

	
	for nbox = 0,boxes-1,1 do
		if boxactive == 1 then
			colbox(boxdata3+(nbox*8),y,x-camx,xa,plcolors)
		end
	end
	
	drawaxis(y,x - camx,2,0xFFFFFFFF)
	end
end

--Rank Display
--Largest Game Training on easy slow 12,533,800
gui:draw_text(210,0,"Base: " .. baserank)
--gui:draw_text(210,8,"Game: " .. gamerank)
gamerank(0x20F9D0,210,10)

--gui:draw_box()
end

function gamerank(adr,x,y)
local u1 = rsb(mem:read_u8(adr+1),2)
local u2 = rsb(mem:read_u8(adr+2),2)
local u3 = rsb(mem:read_u8(adr+3),2)

--
gui:draw_box(x,y+0,x+u1,y+2,0xFFFF0000,0)
gui:draw_box(x,y+0,x+64,y+2,0,0xFFFFFFFF)


gui:draw_box(x,y+3,x+u2,y+5,0xFFFFFF00,0)
gui:draw_box(x,y+3,x+64,y+5,0,0xFFFFFFFF)

gui:draw_box(x,y+6,x+u3,y+8,0xFF00FFFF,0)
gui:draw_box(x,y+6,x+64,y+8,0,0xFFFFFFFF)

end

function other_sprites(adr,colortable)
local active = band(mem:read_u8(adr),0x80)/0x80
local boxactive = band(mem:read_u8(adr),0x02)/0x02
local boxactive2 =  band(mem:read_u8(adr),0x08)/0x08
local y = band(mem:read_i16(adr + 0x2A),0xFF80)/0x80
local x = band(mem:read_i16(adr + 0x2C),0xFF80)/0x80
local xasubpixels = band(mem:read_i16(adr + 0x36),0x7F)
local xa = (mem:read_i16(adr + 0x36) - xasubpixels)/0x80
local boxpnt = mem:read_u32(adr + 0x1A)

local hp = mem:read_u16(adr + 0x50)

if active == 1 then
boxes = 0
	if ((y) < (gui:width()-16)) then
	--	gui:draw_text(y,(x-camx)-24,hexval(adr))
	end
--[[
        if ((y-12) < (gui:width()-16)) then
			if hp ~= 0 then
				gui:draw_text(y-12,(x-camx)-24,"HP: " .. hp)
			end
		end
--]]
		repeat boxes = boxes + 1
	until mem:read_i16(boxpnt + (boxes * 8)) == 0x00
	
	
	for nbox = 0,boxes-1,1 do
		if boxactive == 1 or boxactive2 == 1 then
		colbox(boxpnt+(nbox*8),y,x-camx,xa,colortable)
		end
	end
	drawaxis(y,x - camx,2,0xFFFFFFFF)
end

end

function drawaxis(x,y,l,color)

gui:draw_line(x+l,y,x-l,y,color)
gui:draw_line(x,y+l,x,y-l,color)

end

function colbox(adr,x,y,xaccel,colortable)
local id = band(mem:read_i16(adr + 0x06),0x003F)

x = x - xaccel

local mathx = (mem:read_i16(adr))
local mathy = (mem:read_i16(adr + 0x04))

local basex = mem:read_i16(adr + 0x02)
local basey = mem:read_i16(adr + 0x06) - id


local x1 = (basex-mathx)/0x80
local y1 = (basey-mathy)/0x80

local x2 = (basex+mathx)/0x80
local y2 = (basey+mathy)/0x80

if mathx ~= 0 then
gui:draw_box(x+x1,y+y1,x+x2,y+y2,0,colortable[id+1])
end
end

function hexval(val)
	val = string.format("%X",val)
	return val
end

function band(a,b)
	return a&b
end

function rsb(a,b)
	return a>>b
end
emu.sethook(main,"frame")
