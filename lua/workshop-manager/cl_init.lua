
local function buildWorkshopMenu()
	local dframe = vgui.Create('DFrame')
	dframe:SetSize(ScrW() * 0.3, ScrH() * 0.18)
	dframe:SetTitle("Workshop Outdated!")
	dframe:MakePopup()
	dframe:Center()
	dframe:ShowCloseButton(false)

	local pnl = vgui.Create("DButton", dframe)
    pnl:Dock(TOP)
    pnl:DockMargin(5, 15, 5, 5)
    pnl:SetTall(40)
    pnl:SetText("Open Workshop")
    function pnl:DoClick()
    	steamworks.ViewFile(SimpleWorkshop.collectionID)
    	dframe:Close()
    end

    local pnl = vgui.Create("DButton", dframe)
    pnl:Dock(TOP)
    pnl:DockMargin(5, 0, 5, 5)
    pnl:SetTall(40)
    pnl:SetText('Close')
    function pnl:DoClick()
    	dframe:Close()
    end
end

local function buildWorkshopData(ID)
    local addons = engine.GetAddons()
    local noSubbed, noDownloaded, noMounted;

    http.Post( "https://api.steampowered.com/ISteamRemoteStorage/GetCollectionDetails/v1/",
		{ [ "collectioncount" ] = "1", [ "publishedfileids[0]" ] = tostring( ID ) }, function( result )
		if result then
			local tbl = util.JSONToTable(result)
			for k,v in pairs(tbl) do
				for i, data in pairs(v["collectiondetails"][1]["children"]) do
					if data["publishedfileid"] and !steamworks.IsSubscribed( data["publishedfileid"] ) then
						noSubbed = true
                        if (SimpleWorkshop.print) then
                            steamworks.FileInfo(data["publishedfileid"], function( result )
                                LocalPlayer():PrintMessage( HUD_PRINTTALK, "Missing Workshop Item: " .. data["publishedfileid"] .. " [" ..result.title .. "]");
                            end)
                        end
				    end
				end
			end

            if (noSubbed) then
                buildWorkshopMenu()
            elseif (SimpleWorkshop.print) and (!noSubbed) then
                LocalPlayer():PrintMessage( HUD_PRINTTALK, "Your workshop subscriptions are up to date and mounted." )
            end
		end
	end, function( failed )
		print( failed )
	end )
end


hook.Add( "InitPostEntity", "simpleworkshop.PostEntity", function()
    timer.Simple(5, function()
        local built = buildWorkshopData(SimpleWorkshop.collectionID)
    end)
end)