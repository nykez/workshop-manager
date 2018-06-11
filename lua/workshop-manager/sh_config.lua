SimpleWorkshop = SimpleWorkshop or {}


// Workshop collection ID to check //
SimpleWorkshop.collectionID = "936489973"

// Print to chat the addons they're missing //
SimpleWorkshop.print = false

local function client(file)
	if SERVER then AddCSLuaFile(file) end

	if CLIENT then
		return include(file)
	end
end

if SERVER then
    AddCSLuaFile("cl_init.lua")
end

if CLIENT then
    include("cl_init.lua")
end


MsgC(Color(0, 255, 0), "Loaded Simple Workshop Manager 1.0\n")