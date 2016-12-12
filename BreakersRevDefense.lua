cpu = manager:machine().devices[":maincpu"]
mem = cpu.spaces["program"]
gui = manager:machine().screens[":screen"]

function main()
stanima = mem:read_u8(0x100073)

player(0x10715C,0,0,0x1076BC)--0x560
player(0x1076BC,160,0,0x10715C)
end

--[[
022FA4: move.w  ($266,A4), D0; Base Damage

022F24: move.w  ($1fc,A4), D2; Character Defense Value
022F28: move.w  ($1a8,A4), D1; Character Timer
022F2C: subi.w  #$b4, D1

022F30: bpl     $22f34; if negative clear
022F32: clr.w   D1

022F34: btst    #$7, ($25f,A4);attack type
022F3A: beq     $22f4c


((risktimer<<5)+100)-defense

022F4C: lsr.w   #5, D1
022F4E: addi.w  #$100, D1
022F52: sub.w   D2, D1

022F54: cmpi.w  #$100, D1
022F58: ble     $22f5e
022F5A: move.w  #$100, D1

022F5E: move.b  (-$7f8d,A5), D2 ;Stanima Setting; 2 is default
022F62: ext.w   D2
022F64: add.w   D2, D2
022F66: lea     ($cb8,PC), A0; ($23c20)
022F6A: tst.b   (-$f37,A5);Versus Check

022F6E: beq     $22f74;branch if not versus
022F70: lea     ($cb8,PC), A0; ($23c2a

022F74: move.w  (A0,D2.w), D2;
022F78: mulu.w  D2, D1
022F7A: muls.w  D1, D0

022F7C: lsl.l   #4, D0
022F7E: swap    D0; Final Damage Value

022F80: move.w  D0, D1
022F82: bmi     $22f9e
022F86: mulu.w  ($1a8,A4), D1
022F8A: addi.l  #$500, D1
022F90: divu.w  #$a00, D1
022F94: sub.w   D1, ($1a8,A4)
022F98: bpl     $22f9e
022F9E: movem.l (A7)+, D1-D3/A0
022FA2: rts
022B9A: move.w  ($1f2,A4), D1
022B9E: sub.w   D0, ($1f2,A4)

alsion j2B 67832

01F112: lea     ($4a28,PC), A0; ($23b3c)
01F116: move.w  ($14,A4), D0


]]

function player(adr,x,y,enaddr)
--bp 234fa

	local charid = mem:read_u16(adr + 0x014)
	local riskmeter = mem:read_u16(adr + 0x1A8) - 0xB4

	local atkinputs = mem:read_u32(enaddr + 0x1CA)--Pointer to the asm to detrimine which attack to do covers all attacks and taunt
	local plattkpnt = mem:read_u32(enaddr + 0x1D2)--Data definitely it's own script format

	local life = mem:read_u16(adr + 0x1F2)
	local stun = mem:read_u16(adr + 0x1F8)
	local stunmax = mem:read_u16(adr + 0x1FA)
	local defense = mem:read_i16(adr + 0x1FC)

	local px = mem:read_u16(adr + 0x20E)
	local py = mem:read_u16(adr + 0x212)
	local basedmg = mem:read_u16(adr + 0x266)


	--Opponent
	local baseattk = mem:read_u16(enaddr + 0x254)
	local attkpnt = mem:read_u32(enaddr + 0x1D2)

	--if statements
	if riskmeter < 0 then
	timer = 0
	else
	timer = riskmeter
	end

	local risktest = timer>>5
	local test1 = (risktest + 0x100) - defense

	if test1 < 256 then
	scale = test1
	else
	scale = 256
	end

	if mem:read_u8(0x1070C9) ~= 0 then
	settingaddr = 0x23C2A
	else
	settingaddr = 0x23C20
	end
	--formula data
	local setting =  mem:read_u16((stanima+stanima) + settingaddr)
	local finaldefense = scale*setting
	local damagep1 = (finaldefense*baseattk)*16
	local damagep2 = damagep1>>16

	--display
	--gui:draw_text(x+8,y+8,string.format("Attack Data: %X",plattkpnt))
	gui:draw_box(x+14,y+38,x+98,y+72,0x400020FF,0xFFFFFFFF)
	gui:draw_text(x+16,y+58,"Scale: " .. scale)
	if riskmeter >= 0 then
	--	gui:draw_text(x+64,y+40,"Risk: " .. risktest)--debugdisplay
	end

	gui:draw_text(x+16,y+40,"Defense: " .. defense)
	gui:draw_text(x+16,y+52,"Base Damage: " .. baseattk)
	gui:draw_text(x+16,y+64,string.format("Final Damage: %06d",damagep2))
	gui:draw_box(x+16,y+48,x+64,y+52,0x40FF0000,0xFFFFFFFF)
	gui:draw_box(x+16,y+48,x+(scale/4),y+52,0xFF00FFFF,0xFFFFFFFF)

end



emu.sethook(main,"frame")
