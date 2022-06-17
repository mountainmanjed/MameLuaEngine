--Was exploring damage calculation and seen it would be easy to hack up a combo counter

cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]
gui = manager.machine.screens[":screen"]
rom = manager.machine.memory.regions[":cslot1:maincpu"]

	textbox = {"No ","Yes"}

--Combo Counter hack
--turn hit counter into combo counter
--might mess with score output
--multi hit special fix 3f50
rom:write_u16(0x3f50,0x5268)
rom:write_u16(0x3f52,0x0114)
rom:write_u16(0x3f54,0x0806)
rom:write_u16(0x3f56,0x0001)
rom:write_u16(0x3f58,0x6602)--3f5c

--replace clear flags with jsr
rom:write_u16(0xb1dc,0x4eb9)
rom:write_u32(0xb1de,0x00080000)

--clear flags and hit counter
rom:write_u16(0x80000,0x0228)
rom:write_u16(0x80002,0x00fc)
rom:write_u16(0x80004,0x00bc)
rom:write_u16(0x80006,0x4268)
rom:write_u16(0x80008,0x0114)
rom:write_u16(0x8000a,0x4e75)

function combobox(cx,cy,counter,spec_f,norm_f)
	if counter >= 2 then
		gui:draw_box(cx,cy,cx+56,cy+28,0xffffffff,0xffffffff)
		gui:draw_text(cx+2,cy+2,string.format("%03d Combo",counter),0xff000000)
		gui:draw_text(cx+2,cy+10,string.format("Special Done: %s",textbox[spec_f+1]),0xff000000)
		gui:draw_text(cx+2,cy+18,string.format("Normal Done: %s",textbox[norm_f+1]),0xff000000)
	end
end

function player(c_mem,x,y,color1,color2)

	opponent = mem:read_u32(c_mem+0x14)

	hitbox_id = 0x22

	dat_b8 = 0xb8--attack data
	state4 = 0xbc--defense
	cstate = 0xbf

	hit_counter = mem:read_u16(c_mem+0x114)
	con_atkd0 = 0x11c
	con_atkd1 = 0x11d
	con_atkd2 = 0x11e
	con_atkd3 = 0x11f

	pat_id = 0x120
	state1 = 0x144--
	normaldone = (mem:read_u8(c_mem+0xbc))&1
	specialdone = ((mem:read_u8(c_mem+0xbc))&2)>>1
	char_state = mem:read_u16(c_mem+0xd0)

	hits = mem:read_u16(opponent+0x114)
	opp_sflag =((mem:read_u8(opponent+0xbc))&2)>>1
	opp_nflag =(mem:read_u8(opponent+0xbc))&1

--Figuring out stuff displays
--	gui:draw_box(x,y,x+152,y+20,color1,color2)
--	gui:draw_text(x+2,y+2,string.format("ADDR: %06X",c_mem))
--	gui:draw_text(x+2,y+10,string.format("char state: %X",char_state))
--	gui:draw_text(x+78,y+2,string.format("Hit Combo: %02d",hit_counter))
--	gui:draw_text(x+78,y+10,string.format("Normal Done: %X",normaldone))
--	gui:draw_text(x+78,y+18,string.format("Special Done: %X",specialdone))

	if c_mem == 0x103670 then
		combobox(24,48,hits,opp_sflag,opp_nflag)
	else
		combobox(240,48,hits,opp_sflag,opp_nflag)
	end


end

function main()
	mem:write_u16(0x103a70,0x6340)--time cheat
	mem:write_u8(0x1037b7,0xff)--health cheat
	mem:write_u8(0x1037b8,0xff)--health cheat
	mem:write_u8(0x1039b7,0xff)--health cheat
	mem:write_u8(0x1039b8,0xff)--health cheat
	--dofile("fhdrun.lua")


	player(0x103670,8,32,0xffffffff,0xC0800000)
	player(0x103870,160,32,0xffffffff,0xC0000080)

end



--print()
--print("################################")
--for tag, device in pairs(manager.machine.memory.regions) do print(tag) end
--print()
--print("################################")
--print()
--print()


emu.register_frame_done(main,"frame")
