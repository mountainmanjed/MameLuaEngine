cpu = manager:machine().devices[":maincpu"]
mem = cpu.spaces["program"]
gui = manager:machine().screens[":screen"]

--[[Excerpt from dammit's hitbox script
{	games = {"sfiii3"},
	player = {0x02068C6C, 0x2069104}, --0x498
	object = {initial = 0x02028990, index = 0x02068A96},
	screen = {x = 0x02026CB0, y = 0x02026CB4},
	match  = 0x020154A6,
	scale  = 0x0200DCBA,
	char_id = 0x3C0,
	ptr = {
		valid_object = 0x2A0,
		{offset = 0x2D4, type = "push"},
		{offset = 0x2C0, type = "throwable"},
		{offset = 0x2A0, type = "vulnerability", number = 4},
		{offset = 0x2A8, type = "ext. vulnerability", number = 4},
		{offset = 0x2C8, type = "attack", number = 4},
		{offset = 0x2B8, type = "throw"},
	},
},
]]

function main()
camx = mem:read_u16(0x02026CB0)
camy = mem:read_i16(0x02026CB4)

player(0x02068C6C)
--player(0x2069104) player 2

end

function player(addr)
local flipx = mem:read_u8(addr + 0x0A)
local hitfreeze = mem:read_u16(addr + 0x44)
local plx =  192 + mem:read_i16(addr + 0x64) - camx
local ply =  201 - mem:read_i16(addr + 0x68) + camy

local animationpnt = mem:read_u32(addr + 0x200)

local framecount = mem:read_u8(addr + 0x214)
local cancels = mem:read_u8(addr + 0x221)

--mem:write_u8(addr + 0x222,0x0F) Tengu Stone

local cpnt1 = mem:read_u32(addr + 0x2A0)
local cpnt2 = mem:read_u32(addr + 0x2A8)
local cpnt3 = mem:read_u32(addr + 0x2C8)


local attkpnt = mem:read_u32(addr + 0x2D8) -- Attack data start pointer

local whiffdata1 = mem:read_i16(addr + 0x2F2)-- whiff meter build reads this

local id = mem:read_u16(addr + 0x3C0)
local metpnt = mem:read_u32(addr + 0x3F0)

if flipx ~=0 then 
flip = -1
else
flip = 1
end

collisionbox(cpnt1   ,plx,ply,0xFF00FF40,flip)
collisionbox(cpnt1+ 8,plx,ply,0xFF00FF40,flip)
collisionbox(cpnt1+16,plx,ply,0xFF00FF40,flip)
collisionbox(cpnt1+24,plx,ply,0xFF00FF40,flip)

collisionbox(cpnt2+0x00,plx,ply,0xFFFF0000,flip)
collisionbox(cpnt2+0x08,plx,ply,0xFFFF0000,flip)
collisionbox(cpnt2+0x10,plx,ply,0xFFFF0000,flip)
collisionbox(cpnt2+0x18,plx,ply,0xFFFF0000,flip)

gui:draw_text(2, 0,string.format("ADDR: %X",addr))
gui:draw_text(2, 8,string.format("ID  : %d",id))
gui:draw_text(68, 0,string.format("ANI: %X",animationpnt))

gui:draw_text(44, 32,string.format("FC: %d",framecount))
gui:draw_text(80, 32,string.format("Cancels: %X",cancels))
gui:draw_text(44, 40,string.format("HF: %d",hitfreeze))


drawaxis(plx,ply,8,0xFF00FF00,0xFFFF0000)
end

function collisionbox(adr,playerx,playery,color,flip)

local xl = mem:read_i16(adr + 0x0)
local xr = mem:read_i16(adr + 0x2)
local yb = mem:read_u16(adr + 0x4)
local yt = mem:read_u16(adr + 0x6)

local left = playerx + xl * flip
local right = left + xr * flip
local top = playery - yb
local bottom = top - yt
	
	--gui.line(playerx,playery,left,bottom) To help ID where the box is if your maths is wrong
	gui:draw_box(left,top,right,bottom,0,color)
end

function drawaxis(x,y,axis,color1,color2)
gui:draw_line(x+axis,y,x-axis,y,color1)
gui:draw_line(x,y+axis,x,y-axis,color2)

end

emu.sethook(main,"frame")
