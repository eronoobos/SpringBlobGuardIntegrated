--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Area Guard",
    desc      = "Replace Guard with Area Guard",
    author    = "CarRepairer, zoggop",
    date      = "2014 March",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true,
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- includes

local echo = Spring.Echo


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if gadgetHandler:IsSyncedCode() then -- SYNCED
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- vars



--------------------------------------------------------------------------------
-- functions



--------------------------------------------------------------------------------
-- callins


function gadget:UnitCreated(unitID, unitDefID, team)
	local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD.GUARD)
    if cmdDescID then
        local cmdArray = {hidden = false, type = CMDTYPE.ICON_UNIT_OR_AREA, tooltip = "Guard a unit or all units within a circle."}
        Spring.EditUnitCmdDesc(unitID, cmdDescID, cmdArray)
		-- Spring.InsertUnitCmdDesc(unitID, 500, areaGuardCmd)
    end
end

function gadget:Initialize()
    for _, unitID in ipairs(Spring.GetAllUnits()) do
		local unitDefID = Spring.GetUnitDefID(unitID)
		--local team = spGetUnitTeam(unitID)
		gadget:UnitCreated(unitID, unitDefID, team)
    end
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
else  -- UNSYNCED
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- functions
local function SelectedUnitCanRepair() -- cache this?
	local selUnits = Spring.GetSelectedUnits()
	if not selUnits[1] then
		return nil -- no selected units
	end
	local unitID, unitDefID
	local canRepair
	for i = 1, #selUnits do
		unitID    = selUnits[i]
		unitDefID = Spring.GetUnitDefID(unitID)
		if not unitDefID then
			return
		end
		local ud = UnitDefs[unitDefID]
		if ud.canRepair then
			return true
		end
	end
	return false
end


-------------------------------------------------------------------------------------
-- callins
function gadget:DefaultCommand(type,id)
	if type == 'unit' then
		local target_team = Spring.GetUnitTeam(id)
		if Spring.AreTeamsAllied( target_team, Spring.GetLocalTeamID() ) then
			if SelectedUnitCanRepair() then
				local hp, maxHp,_,_,buildProgress = Spring.GetUnitHealth(id)
				if not buildProgress or buildProgress < 1 or hp < maxHp then
					return -- let the default command be repair
				end
			end
			return CMD.GUARD
		end
	end
end	

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
end
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
