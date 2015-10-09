snd = manager:machine().devices[":audiocpu"]
mem = snd.spaces["program"]
gui = manager:machine().screens[":screen"]

compare = 0
cheats = 0

Addresses = {
0xF600,0xF640,0xF680,0xF6C0,
0xF700,0xF740,0xF780,0xF7C0,
0xF800,0xF840,0xF880,0xF8C0,
0xF900,0xF940,0xF980,0xF9C0
}

--[[
trace bqsound.log,1,{tracelog "AF=%04X BC=%04X DE=%04X HL=%04X IX=%04X IY=%04X PC=",af,bc,de,hl,ix,iy}
ST Sound Engine
Sound FX Tracks
First Track F200
Size 40

0E Volume

20 Activate

Instrument Tracksa
First Track F600
Size 0x40 Bytes
Nothing controls which sample is loaded in the memory

000102 Pointer(add 0x8000 if using mame's :audiocpu) Deals with intruments as well
03
04 Octave (first 4 bits)
05

060708090A

0B Pitch
0C Fine Tune
0D 
0E Volume

0F101112

13 Note
14
15 Note(Slide too?)

161718191A1B1C1D1E1F(Pitch bend is around here)

20 Activate

21
22 
23

2425262728292A2B2C2D2E2F30313233343536

37 Pan  Left 01 ~ 1F Right(Only placed for debugging? since it has no effect while the music is playing)

38393A3B3C3D3E3F

]]

function main()
--Cheats
if cheats == 1 then
--I should make a better way to mute them
--Just comment out the track you want to play
--Track 0
mem:write_u8(0xF600 + 0x20,00)
mem:write_u8(0xF600 + 0x0E,00)

--Track 1
mem:write_u8(0xF640 + 0x20,00)
mem:write_u8(0xF640 + 0x0E,00)

--Track 2 0xF680
mem:write_u8(0xF680 + 0x20,00)
mem:write_u8(0xF680 + 0x0E,00)

--Track 3
mem:write_u8(0xF6C0 + 0x20,00)
mem:write_u8(0xF6C0 + 0x0E,00)

--Track 4
mem:write_u8(0xF700 + 0x20,00)
mem:write_u8(0xF700 + 0x0E,00)

--Track 5
mem:write_u8(0xF740 + 0x20,00)
mem:write_u8(0xF740 + 0x0E,00)

--Track 6
mem:write_u8(0xF780 + 0x20,00)
mem:write_u8(0xF780 + 0x0E,00)

--Track 7
mem:write_u8(0xF7C0 + 0x20,00)
mem:write_u8(0xF7C0 + 0x0E,00)

--Track 8
mem:write_u8(0xF800 + 0x20,00)
mem:write_u8(0xF800 + 0x0E,00)

--Track 9
mem:write_u8(0xF840 + 0x20,00)
mem:write_u8(0xF840 + 0x0E,00)

--Track A
mem:write_u8(0xF880 + 0x20,00)
mem:write_u8(0xF880 + 0x0E,00)

--Track B
mem:write_u8(0xF8C0 + 0x20,00)
mem:write_u8(0xF8C0 + 0x0E,00)

--Track C
mem:write_u8(0xF900 + 0x20,00)
mem:write_u8(0xF900 + 0x0E,00)

--Track D
mem:write_u8(0xF940 + 0x20,00)
mem:write_u8(0xF940 + 0x0E,00)

--Track E
mem:write_u8(0xF980 + 0x20,00)
mem:write_u8(0xF980 + 0x0E,00)

--Track F
mem:write_u8(0xF9C0 + 0x20,00)
mem:write_u8(0xF9C0 + 0x0E,00)

end

if compare == 1 then
insttrack(0,60,0xF700)
insttrack(0,128,0xF740)
else

--9830+8000
--c193+8000
--Main control 0xF000
control = 0xF000
tblstart = rd24bit(control + 0x09,control + 0x0A)
tempo    = mem:read_u16(control + 0x10)
tempoedt = mem:read_u16(control + 0x12) --Can edit
songvol  = mem:read_u8(control + 0x19)

gui:draw_box(300,0,384,32,0xC0EE00DD,0xFFFFFFFF)
gui:draw_text(302, 2,string.format("Tempo: %s,%X",tempoedt,tempoedt))
gui:draw_text(302,10,string.format("Volume: %s",songvol))
gui:draw_text(302,18,string.format("Table: %X",tblstart))

notetrack(  0,  0,0)
notetrack(  0, 32,1)
notetrack(  0, 64,2)
notetrack(  0, 96,3)
notetrack(  0,128,4)
notetrack(  0,160,5)
notetrack(  0,192,6)
notetrack(114, 64,7)
notetrack(114, 96,8)
notetrack(114,128,9)
notetrack(114,160,10)
notetrack(114,192,11)
notetrack(228, 96,12)
notetrack(228,128,13)
notetrack(228,160,14)
notetrack(228,192,15)

end

end

function notetrack(x,y,id)
addr = Addresses[id+1]

pointerp1 = mem:read_u16(addr)
pointerp2 = mem:read_u8(addr+ 0x02)

pointer = pointer


pitch    = mem:read_u8(addr + 0x0B)
finetune = mem:read_u8(addr + 0x0C)
volume   = mem:read_u8(addr + 0x0E)

note1  = mem:read_u8(addr + 0x13)
note2  = mem:read_u8(addr + 0x15)

active = mem:read_u8(addr + 0x20)

pan = mem:read_u8(addr + 0x37)

--Draw graphics 0xAARRBBGG fill,outlin
if active == 0 then
gui:draw_box(x-2,y,x+112,y+32,0,0x80C0C000)
else
gui:draw_box(x-2,y,x+112,y+32,0xC0C00000,0x80C0C000)

gui:draw_text(x +  104,y +  0,string.format("%0X",id))

gui:draw_text(x +  0,y +  0,string.format("%01X%04X",pointerp2,pointerp1))

gui:draw_text(x + 36,y +   8,string.format("PT: %2X",pitch))
gui:draw_text(x + 72,y +   8,string.format("FT: %2X",finetune))
gui:draw_text(x +  2,y +   8,string.format("VL: %2X",volume))

--Notes
gui:draw_text(x +  2,y +  16,string.format("N1: %2X",note1))
gui:draw_text(x +  2,y +  24,string.format("N2: %2X",note2))

--Pan
pangraphic(x+48,y+4,pan)


end
end

function insttrack(x,y,addr)

volume = mem:read_u8(addr + 0x0E)

note1  = mem:read_u8(addr + 0x13)
note2  = mem:read_u8(addr + 0x15)

active = mem:read_u8(addr + 0x20)

setting1 = mem:read_u8(addr + 0x23)
setting2 = mem:read_u8(addr + 0x24)
setting3 = mem:read_u8(addr + 0x25)

--Draw graphics 0xAARRBBGG fill,outline
gui:draw_text(x+12,y-12,string.format("Addr: %X",addr))

--memview
for row = 0,3,1 do
texty = y+row*12 
raddr = addr + row*16 
for i = 0,15,1 do
textx = x+i*12
gui:draw_text(textx+8,texty,string.format("%02X",mem:read_u8(raddr + i)))
end

end

end

function rd24bit(adr8,adr16)
val8  = mem:read_u8(adr8)
val16 = mem:read_u16(adr16)

val = (val8*0x10000) + val16

return val
end

function pangraphic(x,y,val)

val = val-16

gui:draw_line(x-16,y,x+16,y,0xFFFFFFFF)
gui:draw_line(x,y+2,x,y-2,0xFF808080)
gui:draw_line(x-16,y+2,x-16,y-2,0xFF00FFFF)
gui:draw_line(x+16,y+2,x+16,y-2,0xFFFF00FF)

gui:draw_box(x,y+2,x+val,y-2,0xC000FF00,0xFFFFFFFF)


end

emu.sethook(main,"frame")
