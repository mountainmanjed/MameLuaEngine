
function tilemapdump(loc,ender)

::newmap::
	local type = mem:read_u16(loc)
	if loc < ender then

--Type 0
	if type == 0  then
	print(string.format(";#############################################################"))
	print(string.format("loc_%06x:",loc))

	local loop = mem:read_u16(loc+2)
	local hwrd3 = mem:read_u16(loc+4)
	local offsetpnt = mem:read_u32(loc+6)

	print(string.format("    dc.w $%04x,$%04x,$%04x",type,loop,hwrd3))

	print(string.format(";    dc.l loc_%06x FIX ME DUMBASS",offsetpnt))
	print(string.format("    dc.l $%06x ",offsetpnt))

	loc = loc+0xa

		for grab0 = 0,loop-1,1 do
		local w1 = mem:read_u16(loc+0)
		print(string.format("    dc.w $%04x",w1))
		loc = loc+2


		end
		print()
		goto newmap

--Type 2
	elseif type == 2  then
	print(string.format(";#############################################################"))
	print(string.format("loc_%06x:",loc))

	local hwrd2 = mem:read_u16(loc+2)
	local loop = mem:read_u16(loc+4)
	local offsetpnt = mem:read_u32(loc+6)

	print(string.format("    dc.w $%04x,$%04x,$%04x",type,hwrd2,loop))

	print(string.format(";    dc.l loc_%06x FIX ME DUMBASS",offsetpnt))
	print(string.format("    dc.l $%06x ",offsetpnt))

	loc = loc+0xa

		for grab4 = 0,loop,1 do
		local w1 = mem:read_u16(loc+0)
		local w2 = mem:read_u16(loc+2)
		print(string.format("    dc.w $%04x,$%04x",w1,w2))
		loc = loc+4


		end
		print()
		goto newmap

--Type 4
	elseif type == 4 then
	print(string.format(";#############################################################"))
	print(string.format("loc_%06x:",loc))

	local loop = mem:read_u16(loc+2)
	local hwrd3 = mem:read_u16(loc+4)
	local hwrd4 = mem:read_u16(loc+6)
	local hwrd5 = mem:read_u16(loc+8)

	print(string.format("    dc.w $%04x,$%04x,$%04x",type,loop,hwrd3))
	print(string.format("    dc.w $%04x,$%04x",hwrd4,hwrd5))

	loc=loc+10
	for grab = 0,loop-1,1 do
		local w1 = mem:read_u16(loc+0)
		local w2 = mem:read_u16(loc+2)
		print(string.format("    dc.w $%04x,$%04x",w1,w2))
		loc = loc+4

	end

	print()
	goto newmap

--Type 6
	elseif type == 6 then
	print(string.format(";#############################################################"))
	print(string.format("loc_%06x:",loc))

	local hwrd2 = mem:read_u16(loc+2)
	local loop = mem:read_u16(loc+4)
	local hwrd4 = mem:read_u16(loc+6)
	local hwrd5 = mem:read_u16(loc+8)

	print(string.format("    dc.w $%04x,$%04x,$%04x",type,hwrd2,loop))
	print(string.format("    dc.w $%04x,$%04x",hwrd4,hwrd5))

	loc=loc+10
		for grab = 0,loop,1 do
			word1 = mem:read_u16(loc+0)
			word2 = mem:read_u16(loc+2)
			word3 = mem:read_u16(loc+4)
		print(string.format("    dc.w $%04x,$%04x,$%04x",word1,word2,word3))

		loc = loc +6
		end
		print()
		goto newmap

--	elseif type == 0x14 then
	
	else
	print(string.format("loc_%06x:",loc))
	print(string.format("Add Type %02x",type))
	goto forcestop
	end
end
::forcestop::
end
