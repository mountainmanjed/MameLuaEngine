--for i,v in pairs(manager:machine().devices) do print(i) end;
snd = manager:machine().devices[":audiocpu"]
mem = snd.spaces["program"]
gui = manager:machine().screens[":screen"]

compare = 0

--[[
ST Sound Engine
Sound FX Tracks
First Track F200
Size 40

0E Volume

20 Activate

Instrument Tracks
First Track F600
Size 0x40 Bytes
00

0E Volume

13 Note
14
15 Note

20 Activate

]]

function main()

if compare == 1 then
insttrack(0,60,0xF700,4)
insttrack(0,128,0xF740,5)
else
notetrack(2,  0,0xF600,0)
notetrack(2, 32,0xF640,1)
notetrack(2, 64,0xF680,2)
notetrack(2, 96,0xF6C0,3)
notetrack(2,128,0xF700,4)
notetrack(2,160,0xF740,5)
notetrack(2,192,0xF780,6)

notetrack(320,  0,0xF7C0,7)
notetrack(320, 32,0xF800,8)
notetrack(320, 64,0xF840,9)
notetrack(320, 96,0xF880,10)
notetrack(320,128,0xF8C0,11)
notetrack(320,160,0xF900,12)
notetrack(320,192,0xF940,13)

notetrack(128,192,0xF980,14)
notetrack(128+68,192,0xF9C0,15)
end

end

function insttrack(x,y,addr,id)

volume = mem:read_u8(addr + 0x0E)

note1  = mem:read_u8(addr + 0x13)
note2  = mem:read_u8(addr + 0x15)

active = mem:read_u8(addr + 0x20)


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


function notetrack(x,y,addr,id)

volume = mem:read_u8(addr + 0x0E)

note1  = mem:read_u8(addr + 0x13)
note2  = mem:read_u8(addr + 0x15)

active = mem:read_u8(addr + 0x20)


--Draw graphics 0xAARRBBGG fill,outlin
if active ~= 0 then
gui:draw_box(x-2,y,x+64,y+32,0x804040C0,0x80C0C000)
else
gui:draw_box(x-2,y,x+64,y+32,0,0x80C0C000)
end
gui:draw_text(x +  0,y +  0,string.format("Track %02X",id))

gui:draw_text(x +  2,y +   8,string.format("Volume: %2X",volume))

gui:draw_text(x +  2,y +  16,string.format("Note 1: %2X",note1))
gui:draw_text(x +  2,y +  24,string.format("Note 2: %2X",note2))

end



emu.sethook(main,"frame")
