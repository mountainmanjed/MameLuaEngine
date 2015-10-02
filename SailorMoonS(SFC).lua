cpu = manager:machine().devices[":maincpu"]
mem = cpu.spaces["program"]
gui = manager:machine().screens[":screen"]

print("W: " .. gui:width())
print("H: " .. gui:height())

--[[
PC:C11287: BNE c11273 (-$16) Special Moves
113C7 + (Charid*2)

Attack Boxes
AC1F1 + (Charid*2)

Hurt
AC229 + (Charid*2)

Box setup
4809C + CharID *2

80BFD6


]]

--[[
Player Memory Size 0x80

0x00 Character (Byte)

0x04 Animation (Byte)

0x08 Palette Line from Ram (Byte)
0x09 Flip (Byte)

0x0B Graphic Bank

0x20 Actual X(subpixels)
0x21 Actual X
0x22 Actual Y(subpixels)
0x23 Actual Y

0x28 Screen Position X
0x2A Screen Position Y
0x2C Sprite Offset How far off the sprite is from the position (Word) Doesn't effect collision
0x2E Sprite Offset (word)

0x30 Move X
0x32 Move Y
0x40?

0x44 Attack Flag (Byte)
0x45 Damage (Byte)

0x49 Life (Byte)

--]]

--trace smhit2.log,0,{tracelog "S=%04X P=%02X A=%04X X=%04X Y=%04X PB=%02X PC:",s,p,a,x,y,pb}

function main()
--Super Anytime
mem:write_u8(0x080E, 0x0e)
mem:write_u8(0x0810, 0x0e)
mem:write_u8(0x0812, 0x0e)
mem:write_u8(0x0814, 0x0e) 
mem:write_u8(0x0816, 0x0e) 

--Camera
camx = mem:read_i16(0xa00)
camy = mem:read_i16(0xa02)


--Timer
mem:write_u8(0x0804, 0x00)
mem:write_u8(0x0803, 0x07)

pladr = 0x801000 - 0x80

for pl = 0,3,1 do
pladr = pladr + 0x80

local flipb = mem:read_u8(pladr + 0x09) -- Flip flag if byte is anything but zero means the sprite was fliped

local charid = mem:read_u8(pladr)
local plflip = mem:read_u8(pladr + 0x09)
local plx = mem:read_u8(pladr + 0x28)*2 -- Have to multiply X cause of the resolution
local ply = mem:read_u8(pladr + 0x2A)

local movex = mem:read_i16(pladr + 0x30) -- Movement Speed on X
local movey = mem:read_i16(pladr + 0x32) -- Movement Speed on Y

local lifegfx = (0x800800 + pl)

local atk = mem:read_u8(pladr + 0x40) -- Attack Box
local damage = mem:read_u8(pladr + 0x45) -- How much Damage attacks do single hit
local atkflag = mem:read_u8(pladr + 0x44) -- Fire, Knockdown, Electric, etc..
local life = mem:read_u8(pladr + 0x49)
local maxlife = mem:read_u8(pladr + 0x4A)


if charid ~= 0 then
local boxtable = 0x40000 + mem:read_u16(0x4809C + (charid*2))
local attackadr =0xA0000 + mem:read_u16(0xAC1F1 + (charid*2))
local hurttable = 0xA0000 + mem:read_u16(0xAC229 + (charid*2))

local cell = mem:read_u8(pladr + 0x05)*4
local boxes = boxtable + cell

--Hurt
attk = attackadr + mem:read_u8(boxes+1)*8
hurt = hurttable + mem:read_u8(boxes+2)*16

--push = pushtable + mem:read_u8(boxes+3)*8 --Haven't found push table
if pl < 2 then
colbox(hurt,plx,ply,plflip,0x8000FFFF,0xFF00FFFF)
colbox(hurt+8,plx,ply,plflip,0x8000FFFF,0xFF00FFFF)
end

colbox(attk,plx,ply,plflip,0x80ff0000,0xFFFF0000)


	--Health Cheat
	if life <= 24 then
		mem:write_u8(pladr + 0x49,maxlife)
		mem:write_u8(lifegfx,0xC0)
	end
	
	drawaxis(plx,ply,8,0xFFFFFFFF)
	displaytext("Life: " .. life,pl,4,4)
end

end
end

function colbox(adr,px,py,flip,fill,out)

xpos = px + (mem:read_i8(adr)*2)
boxw = xpos + (mem:read_u8(adr + 1)*2)
nxpos =  px + (mem:read_i8(adr+2)*2)
nboxw =  nxpos + (mem:read_u8(adr+3)*2)
ypos = py + mem:read_i8(adr + 4)
boxh = ypos + mem:read_u8(adr + 5)
--Damage = adr + 0x06

if flip == 0 then
	gui:draw_box(xpos,ypos,boxw,boxh,fill,out)
	else
	gui:draw_box(nxpos,ypos,nboxw,boxh,fill,out)
	end

end

function displaytext(textdata,player,x,y)
if player == 0 then
gui:draw_text(x,y,textdata)
elseif player == 1 then
x = 512 - (x + string.len(textdata)*8)
gui:draw_text(x,y,textdata)
end
end

function drawaxis(x,y,l,color)

gui:draw_line(x+(l*2),y,x-(l*2),y,color)
gui:draw_line(x,y+l,x,y-l,color)

end

function hexval(val)
        val = string.format("%X",val)
        return val
end

--Incase of float error on early versions of mame
function band(a,b)
	return a&b
end

function rsb(a,b)
	return a>>b
end

emu.sethook(main,"frame")
