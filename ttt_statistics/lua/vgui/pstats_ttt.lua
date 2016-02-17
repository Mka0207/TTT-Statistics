//TTT Statistics by mka0207.

local COLOR_GRAY = Color(190, 190, 190, 100)
local COLOR_TRANSPARENT = Color(0, 0, 0, 0)
local COLOR_BLACK_ALPHA = Color(0, 0, 0, 180)
local COLOR_WHITE = Color(255, 255, 255, 255)

local SKIN = {}

function SKIN:PaintPropertySheet(panel, w, h)
	local ActiveTab = panel:GetActiveTab()
	local Offset = 0
	if ActiveTab then Offset = ActiveTab:GetTall() - 8 end

	draw.RoundedBox(8, 0, 0, w, h, COLOR_GRAY)
end

function SKIN:PaintTab(panel, w, h)
	if panel:GetPropertySheet():GetActiveTab() == panel then
		return self:PaintActiveTab(panel, w, h)
	end

	draw.RoundedBox(8, 4, 4, w - 4, h - 4, COLOR_TRANSPARENT)
end

function SKIN:PaintActiveTab(panel, w, h)
	draw.RoundedBox(8, 0, 0, w, h, COLOR_TRANSPARENT)
	
end

derma.DefineSkin("ttt_stats", "TEST", SKIN, "Default")

local function StatCenterMouse(self)
	local x, y = self:GetPos()
	local w, h = self:GetSize()
	gui.SetMousePos(x + w * 0.5, y + h * 0.5)
end

local function RefreshList(self) -- called on line 200
	--print( "Refresh Debug!" )

	self.RefreshTime = 5
	self.NextRefresh = self.NextRefresh || 0

	if CurTime() >= self.NextRefresh then
		self.NextRefresh = CurTime() + self.RefreshTime
		self:Refresh()
	end


end

local function DoStatsThink(Window)
	
	if Window and Window:Valid() and Window:IsVisible() then
		local mx, my = gui.MousePos()
		local x, y = Window:GetPos()
		local limit = 100
		if mx < x - limit or my < y - limit or mx > x + Window:GetWide() + limit or my > y + Window:GetTall() + limit then
			Window:SetVisible(false)
			surface.PlaySound("npc/dog/dog_idle3.wav")
		end
	end
	
end

function MakepSelectionTTT(silent)
	if Window and Window:Valid() then
		Window:MakePopup()
		Window:CenterMouse()
		return
	end

	local wide, tall = 400, 200
	
	local pl = LocalPlayer()
	
	local Window = vgui.Create("DFrame")
	Window.Paint = function()
	
		Derma_DrawBackgroundBlur( Window )
		draw.RoundedBox( 16, 0, 0, Window:GetWide(), Window:GetTall(), COLOR_GRAY )
		
	end
	Window:SetSize( wide, tall )
	Window:Center()
	Window:SetTitle("")
	Window:SetDraggable(true)
	Window.CenterMouse = StatCenterMouse
	
	local Panel = vgui.Create( "DPanel", Window )
	Panel:SetSize( wide - 14, tall - 14 )
	Panel:Center()
	Panel.Paint = function()
	
		draw.RoundedBox( 16, 0, 0, Panel:GetWide(), Panel:GetTall(), COLOR_BLACK_ALPHA )
	
	end
	
	if Window.btnMinim and Window.btnMinim:Valid() then Window.btnMinim:SetVisible(false) end
	if Window.btnMaxim and Window.btnMaxim:Valid() then Window.btnMaxim:SetVisible(false) end
	if Window.btnClose and Window.btnClose:Valid() then Window.btnClose:SetVisible(false) end
	
	local headertext = vgui.Create( "DButton", Window )
	headertext:SetText( "TTT Statistics by Mka0207" )
	headertext:SetFont( "DermaLarge" )
	headertext:SetTextColor( COLOR_BLACK_ALPHA )
	headertext:SizeToContents() 
	headertext:SetPos(wide * 0.5 - headertext:GetWide() * 0.5, 25)
	headertext:SetToolTip( "Learn more about Mka0207?" )
	headertext.DoClick = function()
		Window:Remove()
		gui.OpenURL("http://steamcommunity.com/id/mka0207/myworkshopfiles/")
	end
	headertext.Paint = function() 
		DisableClipping( true )
		draw.RoundedBox( 16, -10, -5, headertext:GetWide() + 20, headertext:GetTall() + 10, COLOR_GRAY )
		DisableClipping( false )
	end
	
	DermaImageButtonPanel = vgui.Create( "DPanel", Window )
	DermaImageButtonPanel:AlignLeft( 100 )
	DermaImageButtonPanel:CenterVertical()
	DermaImageButtonPanel:SetSize( 74, 74 )
	DermaImageButtonPanel.Paint = function()
		DisableClipping( true )
			draw.RoundedBox( 16, -5, -5, 74, 74, COLOR_GRAY )
			draw.RoundedBox( 16, 0, 0, 64, 64, COLOR_GREEN )
		DisableClipping( false )
	end
	
	DermaImageButtonPanel2 = vgui.Create( "DPanel", Window )
	DermaImageButtonPanel2:AlignRight( 100 )
	DermaImageButtonPanel2:CenterVertical()
	DermaImageButtonPanel2:SetSize( 64, 64 )
	DermaImageButtonPanel2.Paint = function()
		DisableClipping( true )
			draw.RoundedBox( 16, -5, -5, 74, 74, COLOR_GRAY )
			draw.RoundedBox( 16, 0, 0, 64, 64, COLOR_RED )
		DisableClipping( false )
	end
	
	DermaImageButton = vgui.Create( "DImageButton", DermaImageButtonPanel )
	DermaImageButton:SetImage( "icon16/stat_innocent_selection.png" )	
	DermaImageButton:SetPos( 5, 5 )
	DermaImageButton:SetSize( 54, 54 )
	DermaImageButton:SetToolTip( "Open the Innocent Statistics?" )
	DermaImageButton.DoClick = function()
		Window:Remove()
		MakepInnocentStats()
	end
	
	DermaImageButton2 = vgui.Create( "DImageButton", DermaImageButtonPanel2 )
	DermaImageButton2:SetImage( "icon16/stat_traitor_selection.png" )	
	DermaImageButton2:SetPos( 5, 5 )
	DermaImageButton2:SetSize( 54, 54 )
	DermaImageButton2:SetToolTip( "Open the Traitor Statistics?" )
	DermaImageButton2.DoClick = function()
		Window:Remove()
		MakepTraitorStats()
	end
	
	hook.Add("Think", "MakepSelectionTTTThink", function() DoStatsThink(Window) end)
	
	Window:MakePopup()
end

function MakepInnocentStats(silent)
	if Window and Window:Valid() then
		Window:MakePopup()
		Window:CenterMouse()
		return
	end

	local wide, tall = 800, 480
	
	local pl = LocalPlayer()

	local Window = vgui.Create("DFrame")
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle("")
	Window:SetDraggable(false)
	Window:SetDeleteOnClose(true)
	Window:SetKeyboardInputEnabled(false)
	Window:SetCursor( "pointer" )
	Window.CenterMouse = StatCenterMouse
		Window.Paint = function()
	
		Derma_DrawBackgroundBlur( Window )
		draw.RoundedBox( 16, 0, 0, Window:GetWide(), Window:GetTall(), COLOR_GRAY )
		
	end	
	
	if Window.btnMinim and Window.btnMinim:Valid() then Window.btnMinim:SetVisible(false) end
	if Window.btnMaxim and Window.btnMaxim:Valid() then Window.btnMaxim:SetVisible(false) end
	if Window.btnClose and Window.btnClose:Valid() then Window.btnClose:SetVisible(false) end
	
	local Panel = vgui.Create( "DPanel", Window )
	Panel:SetSize( wide - 14, tall - 14 )
	Panel:Center()
	Panel.Paint = function()
	
		draw.RoundedBox( 16, 0, 0, Panel:GetWide(), Panel:GetTall(), COLOR_BLACK_ALPHA )
	
	end
	
	local returnbutton = vgui.Create( "DButton", Panel )
	--returnbutton:SetImage( "icon16/arrow_undo.png" )	
	returnbutton:SetText( "Back" )
	returnbutton:SetFont( "DermaLarge" )
	returnbutton:AlignBottom(20)
	returnbutton:AlignLeft(25)
	returnbutton:SizeToContents()
	returnbutton.DoClick = function()
		Window:Remove()
		MakepSelectionTTT()
		Window:CenterMouse()
	end
	returnbutton.Paint = function()
		DisableClipping(true)
			draw.RoundedBox( 16, -10, 0, returnbutton:GetWide() + 20, returnbutton:GetTall(), COLOR_GRAY )
		DisableClipping(false)
	end
	
		local closebutton = vgui.Create( "DButton", Panel )
	--closebutton:SetImage( "icon16/cancel.png" )	
	closebutton:SetText( "Close" )
	closebutton:SetFont( "DermaLarge" )
	closebutton:AlignBottom(20)
	closebutton:AlignRight(25)
	closebutton:SizeToContents()
	closebutton.DoClick = function()
		Window:Remove()
	end
	closebutton.Paint = function()
		DisableClipping(true)
			draw.RoundedBox( 16, -10, 0, closebutton:GetWide() + 20, closebutton:GetTall(), COLOR_GRAY )
		DisableClipping(false)
	end

	local propertysheet = vgui.Create( "DPropertySheet", Window )
	propertysheet:StretchToParent( 40, 40, 40, 64 )

	local DermaListView_INNOCENT = vgui.Create("DListView")
	DermaListView_INNOCENT:SetParent(propertysheet)
	DermaListView_INNOCENT:SetPos( 25, 50 )
	DermaListView_INNOCENT:SetSize( 600, 625 )
	DermaListView_INNOCENT:SetMultiSelect(false)
	DermaListView_INNOCENT:AddColumn("Name")
	DermaListView_INNOCENT:AddColumn("Traitors Decapitated")
	DermaListView_INNOCENT:AddColumn("Traitors Killed")
	DermaListView_INNOCENT:AddColumn("Innocent Wins")
	DermaListView_INNOCENT:AddColumn("Innocent Deaths")
	DermaListView_INNOCENT:SetSortable( true )
	--DermaListView_INNOCENT.Think = RefreshList
	
	DermaListView_INNOCENT.Paint = 
	function( self )
	
		--self:RefreshList()
		
		draw.RoundedBox( 16, 1, -5, DermaListView_INNOCENT:GetWide() - 4, DermaListView_INNOCENT:GetTall(), COLOR_WHITE )

	end
 
	DermaListView_INNOCENT.RefreshList = function(self)
	
		self:Clear()
			
		for k,v in pairs(player.GetAll()) do
			local name = v:Name()
			local tdecaps = tonumber( v:GetNWInt( "traitor_decaps" ) )
			local tkills = tonumber( v:GetNWInt( "traitor_killed" ) )
			local innowins = tonumber( v:GetNWInt( "innocent_wins" ) )
			local innodeaths = tonumber( v:GetNWInt( "innocent_deaths" ) )

			local line = self:AddLine(name, string.Comma(tdecaps), string.Comma(tkills), string.Comma(innowins), string.Comma(innodeaths))
			
			line:SetSortValue( 2, tdecaps )
			line:SetSortValue( 3, tkills )
			line:SetSortValue( 4, innowins )
			line:SetSortValue( 5, innodeaths )
		end
		
	end
	
	DermaListView_INNOCENT.DoDoubleClick = DermaListView_INNOCENT.RefreshList

	DermaListView_INNOCENT:RefreshList()
	
	//Todo "Weapon Stats"
	--[[local DermaListView_WEAPONS = vgui.Create("DListView")
	DermaListView_WEAPONS:SetParent(propertysheet)
	DermaListView_WEAPONS:SetPos( 25, 50 )
	DermaListView_WEAPONS:SetSize( 600, 625 )
	DermaListView_WEAPONS:SetMultiSelect(false)
	DermaListView_WEAPONS:AddColumn("Name")
	DermaListView_WEAPONS:AddColumn("Crowbar Kills")
	DermaListView_WEAPONS:AddColumn("Pistol Kills")
	DermaListView_WEAPONS:AddColumn("MAC10 Kills")
	DermaListView_WEAPONS:AddColumn("Deagle Kills")
	DermaListView_WEAPONS:AddColumn("Scout Kills")
	DermaListView_WEAPONS:AddColumn("LMG Kills")
	DermaListView_WEAPONS:SetSortable( true )
	DermaListView_WEAPONS.Paint = 
	function( self )
		draw.RoundedBox( 16, 0, 0, DermaListView_WEAPONS:GetWide(), DermaListView_WEAPONS:GetTall(), COLOR_GREEN )
	end
	DermaListView_WEAPONS.RefreshList = function(self)
		self:Clear()
		for k,v in pairs(player.GetAll()) do
			local name = v:Name()
			local zkills = tonumber( v:GetNWInt( "humancounter" ) )
			local headshots = tonumber( v:GetNWInt( "headshotcounter" ) )
			local assists = tonumber( v:GetNWInt( "assistcounter" ) )
			local humanwins = tonumber( v:GetNWInt( "humanwins" ) )
			local humandeaths = tonumber( v:GetNWInt( "humandeaths" ) )
			local line = self:AddLine(name, string.Comma(zkills), string.Comma(headshots), string.Comma(assists), string.Comma(humanwins), string.Comma(humandeaths))
			line:SetSortValue( 2, zkills )
			line:SetSortValue( 3, headshots )
			line:SetSortValue( 4, assists )
			line:SetSortValue( 5, humanwins )
			line:SetSortValue( 6, humandeaths )
		end
	end
	DermaListView_WEAPONS.DoDoubleClick = DermaListView_WEAPONS.RefreshList
	DermaListView_WEAPONS:RefreshList()]]
	
		
	--propertysheet.AddSheet = function(label, panel, material, NoStretchX, NoStretchY, Tooltip) 
	--end
	
	propertysheet:AddSheet( "Basic Innocent Statistics", DermaListView_INNOCENT, "icon16/stat_innocent.png", false, false, "" )
	propertysheet:SetSkin( "ttt_stats" )
	--propertysheet:AddSheet( "Weapon Stats", DermaListView_WEAPONS, "icon16/gun.png", false, false, "Normal Stats for all Human players." )

	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.5, 0)
	Window:MakePopup()
end

function MakepTraitorStats(silent)
	if Window and Window:Valid() then
		Window:MakePopup()
		Window:CenterMouse()
		return
	end


	local wide, tall = 800, 480
	
	local pl = LocalPlayer()

	local Window = vgui.Create("DFrame")
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle("")
	Window:SetDraggable(false)
	Window:SetDeleteOnClose(true)
	Window:SetKeyboardInputEnabled(false)
	Window:SetCursor("pointer")
	Window.CenterMouse = StatCenterMouse
	Window.Paint = function()
	
		Derma_DrawBackgroundBlur( Window )
		draw.RoundedBox( 16, 0, 0, Window:GetWide(), Window:GetTall(), COLOR_GRAY )
		
	end	
	
	
	if Window.btnMinim and Window.btnMinim:Valid() then Window.btnMinim:SetVisible(false) end
	if Window.btnMaxim and Window.btnMaxim:Valid() then Window.btnMaxim:SetVisible(false) end
	if Window.btnClose and Window.btnClose:Valid() then Window.btnClose:SetVisible(false) end
	
	local Panel = vgui.Create( "DPanel", Window )
	Panel:SetSize( wide - 14, tall - 14 )
	Panel:Center()
	Panel.Paint = function()
	
		draw.RoundedBox( 16, 0, 0, Panel:GetWide(), Panel:GetTall(), COLOR_BLACK_ALPHA )
	
	end
	
	local returnbutton = vgui.Create( "DButton", Panel )
	--returnbutton:SetImage( "icon16/arrow_undo.png" )	
	returnbutton:SetText( "Back" )
	returnbutton:SetFont( "DermaLarge" )
	returnbutton:AlignBottom(20)
	returnbutton:AlignLeft(25)
	returnbutton:SizeToContents()
	returnbutton.DoClick = function()
		Window:Remove()
		MakepSelectionTTT()
		Window:CenterMouse()
	end
	returnbutton.Paint = function()
		DisableClipping(true)
			draw.RoundedBox( 16, -10, 0, returnbutton:GetWide() + 20, returnbutton:GetTall(), COLOR_GRAY )
		DisableClipping(false)
	end
	
		local closebutton = vgui.Create( "DButton", Panel )
	--closebutton:SetImage( "icon16/cancel.png" )	
	closebutton:SetText( "Close" )
	closebutton:SetFont( "DermaLarge" )
	closebutton:AlignBottom(20)
	closebutton:AlignRight(25)
	closebutton:SizeToContents()
	closebutton.DoClick = function()
		Window:Remove()
	end
	closebutton.Paint = function()
		DisableClipping(true)
			draw.RoundedBox( 16, -10, 0, closebutton:GetWide() + 20, closebutton:GetTall(), COLOR_GRAY )
		DisableClipping(false)
	end
	
	local propertysheet = vgui.Create("DPropertySheet", Window)
	propertysheet:StretchToParent( 40, 40, 40, 64 )

	local DermaListView_TRAITOR = vgui.Create("DListView")
	DermaListView_TRAITOR:SetParent(Window)
	DermaListView_TRAITOR:SetPos(25, 50)
	DermaListView_TRAITOR:SetSize(64, 64)
	DermaListView_TRAITOR:SetMultiSelect(false)
	DermaListView_TRAITOR:AddColumn("Name")
	DermaListView_TRAITOR:AddColumn("Innocents Killed")
	DermaListView_TRAITOR:AddColumn("Detectives Killed")
	DermaListView_TRAITOR:AddColumn("Traitor Wins")
	DermaListView_TRAITOR:AddColumn("Traitor Deaths")
	DermaListView_TRAITOR:SetSortable( true )
	
	DermaListView_TRAITOR.Paint = 
	function(self)
	
		--self:RefreshList()
		
		draw.RoundedBox( 16, 1, -5, DermaListView_TRAITOR:GetWide() - 6, DermaListView_TRAITOR:GetTall(), COLOR_WHITE )

	end
	
	DermaListView_TRAITOR.RefreshList = function(self)
	
		self:Clear()
 
		for k,v in pairs(player.GetAll()) do
			local name = v:Name()
			local innokilled = tonumber( v:GetNWInt( "innocent_killed" ) )
			local deteckilled = tonumber( v:GetNWInt( "detective_killed" ) )
			local twins = tonumber( v:GetNWInt( "traitor_wins" ) )
			local tdeaths = tonumber( v:GetNWInt( "traitor_deaths" ) )

			local line = self:AddLine(name, string.Comma(innokilled), string.Comma(deteckilled), string.Comma(twins), string.Comma(tdeaths))

			line:SetSortValue( 2, innokilled )
			line:SetSortValue( 3, deteckilled )
			line:SetSortValue( 4, twins )
			line:SetSortValue( 5, tdeaths )
		end
	
		
	end
	
	DermaListView_TRAITOR.DoDoubleClick = DermaListView_TRAITOR.RefreshList

	DermaListView_TRAITOR:RefreshList()

	propertysheet:AddSheet( "Basic Traitor Statistics", DermaListView_TRAITOR, "icon16/stat_traitor.png", false, false, "" )
	propertysheet:SetSkin( "ttt_stats" )
	


	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.5, 0)
	Window:MakePopup()
end
