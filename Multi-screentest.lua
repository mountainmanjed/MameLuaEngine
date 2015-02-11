--Test for Multiscreen Games
guils = manager:machine().screens[":lscreen"]
guims = manager:machine().screens[":mscreen"]
guirs = manager:machine().screens[":rscreen"]


function main()
guils:draw_box(0, 0, 64, 64, 0xff80000, 0xffffffff)
guils:draw_text(16, 16, "Left Screen")

guims:draw_box(0, 0, 64, 64, 0xff008000, 0xffffffff)
guims:draw_text(16, 16, "Middle Screen")

guirs:draw_box(0, 0, 64, 64, 0xFF000080, 0xffffffff)
guirs:draw_text(16, 16, "Right Screen")
end

emu.sethook(main, "frame")
