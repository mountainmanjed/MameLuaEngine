--for Street Fighter Alpha 3 cps2

cpu = manager:machine().devices[":maincpu"]
mem = cpu.spaces["program"]
gui = manager:machine().screens[":screen"]

	dofile "tilemapgrab.lua"

function grabber(loc,numpointers)
--pointers
	aismpnt1 = mem:read_u32(loc+0x0)
	aismpnt2 = mem:read_u32(loc+0x4)
	aismpnt3 = mem:read_u32(loc+0x8)
	aismpnt4 = mem:read_u32(loc+0xc)

	xismpnt1 = mem:read_u32(loc+0x10)
	xismpnt2 = mem:read_u32(loc+0x14)
	xismpnt3 = mem:read_u32(loc+0x18)
	xismpnt4 = mem:read_u32(loc+0x1c)

	vismpnt1 = mem:read_u32(loc+0x20)
	vismpnt2 = mem:read_u32(loc+0x24)
	vismpnt3 = mem:read_u32(loc+0x28)
	vismpnt4 = mem:read_u32(loc+0x2c)

	print(string.format("loc_%06x:",loc))
	print(string.format(";A-ism/Z-ism"))
	print(string.format("    dc.l loc_%06x,loc_%06x,loc_%06x,loc_%06x",aismpnt1,aismpnt2,aismpnt3,aismpnt4))

	print(string.format(";X-ism"))
	print(string.format("    dc.l loc_%06x,loc_%06x,loc_%06x,loc_%06x",xismpnt1,xismpnt2,xismpnt3,xismpnt4))

	print(string.format(";V-ism"))
	print(string.format("    dc.l loc_%06x,loc_%06x,loc_%06x,loc_%06x",vismpnt1,vismpnt2,vismpnt3,vismpnt4))
	print(string.format(""))

	local base = loc+0x30
	local wordloc = loc+0x30

	--jumptable word
	for grabtimes = 0,numpointers-1,1 do
	print(string.format("loc_%06x:",wordloc))

::wordread::
	local readloc = mem:read_u16(wordloc)
		if readloc ~= 0000 then
		print(string.format("    dc.w loc_%06x-loc_%06x",readloc+base,base))
		wordloc = wordloc+2
		goto wordread

		else
		wordloc = wordloc+2
		base = wordloc
		print(string.format("    dc.w 0000"))
		print(string.format(""))
		end
	end

--	animationdata


end

function animationdata(start,last)
	local loc = start

::begin::
if loc < last then
	print (";##############################################################")

::moreanimation::
	local nextendflag = mem:read_u8(loc+0x1)

	if nextendflag == 0 then
		local count = mem:read_u8(loc+0x0)
		local endflag = mem:read_u8(loc+0x1)
		local byte3 = mem:read_u8(loc+0x2)
		local byte4 = mem:read_u8(loc+0x3)
		local tilemap = mem:read_u32(loc+0x4)
		local word1 = mem:read_u16(loc+0x8)
		local word2 = mem:read_u16(loc+0xa)
		local word3 = mem:read_u16(loc+0xc)
		local word4 = mem:read_u16(loc+0xe)
		local word5 = mem:read_u16(loc+0x10)
		local word6 = mem:read_u16(loc+0x12)

		print(string.format("loc_%06x:",loc))
		print(string.format("    dc.b $%02x,$%02x,$%02x,$%02x",count,endflag,byte3,byte4))
		print(string.format("    dc.l loc_%06x",tilemap))
		print(string.format("    dc.w $%04x,$%04x,$%04x",word1,word2,word3))
		print(string.format("    dc.w $%04x,$%04x,$%04x",word4,word5,word6))
		print()
		loc=loc+0x14
		goto moreanimation

	else
		local count = mem:read_u8(loc+0x0)
		local endflag = mem:read_u8(loc+0x1)
		local byte3 = mem:read_u8(loc+0x2)
		local byte4 = mem:read_u8(loc+0x3)
		local tilemap = mem:read_u32(loc+0x4)
		local word1 = mem:read_u16(loc+0x8)
		local word2 = mem:read_u16(loc+0xa)
		local word3 = mem:read_u16(loc+0xc)
		local word4 = mem:read_u16(loc+0xe)
		local word5 = mem:read_u16(loc+0x10)
		local word6 = mem:read_u16(loc+0x12)

		print(string.format("loc_%06x:",loc))
		print(string.format("    dc.b $%02x,$%02x,$%02x,$%02x",count,endflag,byte3,byte4))
		print(string.format("    dc.l loc_%06x",tilemap))
		print(string.format("    dc.w $%04x,$%04x,$%04x",word1,word2,word3))
		print(string.format("    dc.w $%04x,$%04x,$%04x",word4,word5,word6))
		print()

			if endflag == 0x80 then
				looppnt = mem:read_u32(loc+0x14)
				print(string.format("    dc.l loc_%06x",looppnt))
				print()
				loc=loc+0x18
				else
				loc=loc+0x14
			end
		
			goto begin
		end
	end
end

function pointergrab(loc)
	base = loc
	wordloc = loc

	print(string.format(";#############################################################"))
	print(string.format("loc_%06x:",loc))

	::wordpnt::
	local readloc = mem:read_i16(wordloc)

	if readloc ~= 0000 then
		print(string.format("    dc.w loc_%06x-loc_%06x",readloc+base,base))
		wordloc = wordloc+2
		goto wordpnt

		else
		wordloc = wordloc+2
		base = wordloc
		print(string.format("    dc.w 0000"))
		print(string.format(""))
	end
end


function smallanim(start,last)
	local loc = start

::begin::
if loc < last then
	print (";##############################################################")

::moreanimation::
	local nextendflag = mem:read_u8(loc+0x1)

	if nextendflag == 0 then
		local count = mem:read_u8(loc+0x0)
		local endflag = mem:read_u8(loc+0x1)
		local byte3 = mem:read_u8(loc+0x2)
		local byte4 = mem:read_u8(loc+0x3)
		local tilemap = mem:read_u32(loc+0x4)

		print(string.format("loc_%06x:",loc))
		print(string.format("    dc.b $%02x,$%02x,$%02x,$%02x",count,endflag,byte3,byte4))
		print(string.format("    dc.l loc_%06x",tilemap))
		print()
		loc=loc+0x8
		goto moreanimation

	else
		local count = mem:read_u8(loc+0x0)
		local endflag = mem:read_u8(loc+0x1)
		local byte3 = mem:read_u8(loc+0x2)
		local byte4 = mem:read_u8(loc+0x3)
		local tilemap = mem:read_u32(loc+0x4)

		print(string.format("loc_%06x:",loc))
		print(string.format("    dc.b $%02x,$%02x,$%02x,$%02x",count,endflag,byte3,byte4))
		print(string.format("    dc.l loc_%06x",tilemap))
		print()

			if endflag == 0x80 then
				looppnt = mem:read_u32(loc+0x08)
				print(string.format("    dc.l loc_%06x",looppnt))
				print()
				loc=loc+0x0c
				else
				loc=loc+0x08
			end
		
			goto begin
		end
	end
end

function pntgrabamt(loc,num)
	base = loc
	wordloc = loc

	print(string.format(";#############################################################"))
	print(string.format("loc_%06x:",loc))

	for pointers = 0,num-1,1 do
		local readloc = mem:read_i16(wordloc)
		print(string.format("    dc.w loc_%06x-loc_%06x",readloc+base,base))
		wordloc = wordloc+2
	end
end

--for pointers at the start of the animation
--works for everyone but Gen and Chun
--grabber(0x270f16,4)

--grab animation data
--animationdata(start,end)

--for projectiles
--pointergrab(sets all the jump tables)
--smallanim(0x2763b6,0x276bc6)--type of animation with less data

--made specfically for chun
--a few of her projectile animations
--don't end with a 0
--pntgrabamt(0x17bf3c,33)

--Dumping the tilemaps for the sprites only supports sprite formats 0,2,4,6
--tilemapdump(0x276e56,0x27dc4a)
