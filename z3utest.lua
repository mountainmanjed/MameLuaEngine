cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
gui = manager.machine.screens[":screen"]

--[[
To Do / Problems
	Scaling needs fixed
	Find Projectiles
	Needs frame Delay to match up
	Throw boxes
	Find Global States to say when in match
]]

--scaling values
cpsx = 640/384
cpsy = 480/224


function draw_axis(x,y,s)
	local sx = s*cpsx
	local sy = s*cpsy
	gui:draw_line(x-sx,y,x+sx,y,0xffffff00)
	gui:draw_line(x,y-sy,x,y+sy,0xffff00ff)
end

function draw_colbox(px,py,pnt,flip,color1,color2)
	local bxo = ((mem:read_i16(pnt+0)*flip)*cpsx)+px
	local byo = py-(mem:read_i16(pnt+2)*cpsy)
	local bxr = mem:read_u16(pnt+4)*cpsx
	local byr = mem:read_u16(pnt+6)*cpsy

	local l = bxo-bxr;
	local r = bxo+bxr;
	local t = byo-byr;
	local b = byo+byr;

	gui:draw_box(l,t,r,b,color1,color2)

end

function player(addr,x,y,color1)
	
	local plx = mem:read_i16(addr+0x12)*cpsx
	local ply = mem:read_i16(addr+0x16)*cpsy
	
	local plflip = mem:read_u8(addr+0xb)

	local anim_pnt = mem:read_u32(addr+0x1c)

--[[
	animation data 10 bytes

	00 framecount ending flags
	02 renda
	03
	04 cell gfx id
	06
	07
	08 deals with extra data
--]]
	

	local pl_cbset_pnt = mem:read_u32(addr+0xb8)
	local pl_unkn_pnt = mem:read_u32(addr+0xbc)
	local pl_head_pnt = mem:read_u32(addr+0xc0)
	local pl_body_pnt = mem:read_u32(addr+0xc4)
	local pl_legs_pnt = mem:read_u32(addr+0xc8)
	local pl_push_pnt = mem:read_u32(addr+0xcc)
	local pl_attk_pnt = mem:read_u32(addr+0xd0)


	local taunt_count = mem:read_u8(addr + 0xee)
	
	local activebox = mem:read_u32(addr+0xf0)

--all the stuff that they cut off the original animation data
	local pnt_118 = mem:read_u32(addr+0x118)


	local charid = mem:read_u8(addr+0x142)



--math section
	local use_x = plx-cam_x
	local use_y = (cam_y-ply)+(236*cpsy)--224
	local xflip = (-1)^(plflip&1)



--boxes
	local boxset = mem:read_u32(activebox)

	local head_loc = pl_head_pnt+(mem:read_u8(activebox+00)*8);
	local body_loc = pl_body_pnt+(mem:read_u8(activebox+01)*8);
	local legs_loc = pl_legs_pnt+(mem:read_u8(activebox+02)*8);
	local push_loc = pl_push_pnt+(mem:read_u8(activebox+03)*8);

--
--8c055b50 jsr to col check

	local attk_id = (mem:read_u8(pnt_118+1))
	local attk_loc = pl_attk_pnt+attk_id*0x20;


--draw stuff
	draw_axis(use_x,use_y,4)
	draw_colbox(use_x,use_y,head_loc,xflip,0xff2233ff,0x442233ff)
	draw_colbox(use_x,use_y,body_loc,xflip,0xff2233ff,0x442233ff)
	draw_colbox(use_x,use_y,legs_loc,xflip,0xff2233ff,0x442233ff)
	draw_colbox(use_x,use_y,push_loc,xflip,0xffffff44,0x44444444)
	draw_colbox(use_x,use_y,attk_loc,xflip,0xffff0000,0x44ff0000)

--Hud
	gui:draw_box(x,y,x+320,y+64,0xffffffff,color1)
	
	gui:draw_text(x+2,y+2,string.format("ADDR: %08X, flip; %d",addr,xflip))
	gui:draw_text(x+2,y+18,string.format("cbset Pnt: %08x,%08x",pl_cbset_pnt,activebox))
	gui:draw_text(x+2,y+34,string.format("anim Pnt: %08x",anim_pnt))
	gui:draw_text(x+2,y+50,string.format("box pnt: %08x,%02x",pl_attk_pnt,attk_id))


end


function main()

	--camera
	cam_x = mem:read_i16(0xc429046)*cpsx
	cam_y = mem:read_i16(0xc42904a)*cpsy

	mem:write_u8(0x0C420219,0x63) -- infinite time

	--player size 45c
	player(0xc4202e8,16,0,0x80aa0000)
	player(0xc420744,348,0,0x800000aa)
	--player(0xc420ba0,0,0)
	--player(0xc420ffc,0,0)
end



emu.register_frame_done(main,"frame")