-- This script is designed to be placed on a Panel object in Tabletop Simulator.
-- It detects when an object is dropped directly on the panel.

-- The unique identifier for the injected script.
local SCRIPT_IDENTIFIER = "--[dnd-measurement-injector]--"

-- This is the template for the script that will be injected into miniatures.
-- It is a single, robust multi-line string.
local SCRIPT_TO_INJECT_TEMPLATE = [[
	]] .. SCRIPT_IDENTIFIER .. [[

	function onPickUp(color)
		local gridX = Grid and Grid.sizeX or 2
		local startPos = self.getPosition()

		for _, hit in ipairs(Physics.cast({
			origin = self.getBounds().center,
			direction = {0, -1, 0},
			type = 1,
			max_distance = 10
		})) do
			if hit.point and hit.hit_object ~= self then
				startPos = hit.point
				break
			end
		end

		local token = spawnObject({
			type = "Custom_Tile",
			position = startPos,
			rotation = {0, Player[color].getPointerRotation(), 0},
			scale = {gridX / 2.2, 0.1, gridX / 2.2}
		})

		token.setLock(true)
		token.setCustomObject({
			image = "https://steamusercontent-a.akamaihd.net/ugc/1021697601906583980/C63D67188FAD8B02F1B58E17C7B1DB304B7ECBE3/",
			thickness = 0.1,
			type = 2
		})
		token.interactable = false

		token.createButton({
			click_function = "noop",
			function_owner = self,
			label = "00",
			position = {0, 0.1, 0},
			width = 0, height = 0,
			font_size = 600
		})

		local parentGUID = self.getGUID()
		token.setLuaScript([=[
			function onUpdate()
				local parent = getObjectFromGUID("]=] .. parentGUID .. [=[")
				if parent and parent.held_by_color then
					if (not time_of_release) then
						local gridX = Grid and Grid.sizeX or 2
						local diff = self.getPosition() - parent.getPosition()
						diff.y = 0
						local dist = math.max(math.abs(diff.x), math.abs(diff.z)) * (5.0 / gridX)
						self.editButton({index=0, label=tostring(math.floor((dist+2.5)/5.0))})
					end
				else
					-- The object is NOT being held.
					-- Start the timer if it hasn't been started yet.
					if time_of_release == nil then
						time_of_release = os.clock()
					end

					-- Check if 3 seconds have passed since release.
					if os.clock() - time_of_release >= 3 then
						destroyObject(self)
					end
				end
			end
		]=])
	end

	function noop() end

]]

--------------------------------------------------------------------------------

-- onObjectDrop is a global function that triggers when an object is dropped anywhere on the table.
-- The `self` variable here refers to the panel.
function onObjectDrop(player_color, dropped_object)
    -- Ignore the event if the panel itself is the object being dropped.
    if self.getGUID() == dropped_object.getGUID() then
        return
    end

    -- Helper function to calculate the minimum and maximum coordinates of an object's bounding box.
    local function getObjectBounds(obj)
        local bounds = obj.getBounds()
        local min_pos = Vector(bounds.center.x - bounds.size.x / 2,
                               bounds.center.y - bounds.size.y / 2,
                               bounds.center.z - bounds.size.z / 2)
        local max_pos = Vector(bounds.center.x + bounds.size.x / 2,
                               bounds.center.y + bounds.size.y / 2,
                               bounds.center.z + bounds.size.z / 2)
        return min_pos, max_pos
    end

    -- Define the height of the "drop zone" above the panel.
    local drop_zone_height = 5

    -- Get the bounding box of the panel and the dropped object using our helper function.
    local panel_min_pos, panel_max_pos = getObjectBounds(self)
    local dropped_obj_min_pos, dropped_obj_max_pos = getObjectBounds(dropped_object)

    -- Extend the panel's max Y boundary to include the drop zone height.
    panel_max_pos.y = panel_max_pos.y + drop_zone_height

    -- Check for an overlap between the two bounding boxes.
    if (dropped_obj_min_pos.x < panel_max_pos.x and dropped_obj_max_pos.x > panel_min_pos.x) and
       (dropped_obj_min_pos.y < panel_max_pos.y and dropped_obj_max_pos.y > panel_min_pos.y) and
       (dropped_obj_min_pos.z < panel_max_pos.z and dropped_obj_max_pos.z > panel_min_pos.z) then

        -- Determine if the panel is upside down by checking its rotation.
        local rotation = self.getRotation()
        local panel_orientation = "right way up"
        if math.abs(rotation.x) > 170 or math.abs(rotation.z) > 170 then
            panel_orientation = "upside down"
        end

        -- Check if the dropped object has a tag that identifies it as a miniature.
        local valid_tags = {"Miniature", "Figurine", "Figure", "Model"}
        local is_miniature = false
        for _, tag in ipairs(valid_tags) do
            if dropped_object.tag == tag then
                is_miniature = true
                break
            end
        end

        if is_miniature then
            if panel_orientation == "right way up" then
                -- This is the "Inject" side. Add the script if it's not already there.
                local current_script = dropped_object.getLuaScript()
                
                if current_script == "" or not current_script:find(SCRIPT_IDENTIFIER, 1, true) then
                    dropped_object.setLuaScript(SCRIPT_TO_INJECT_TEMPLATE)
                    broadcastToAll("Script injected into '" .. dropped_object.getName() .. "'!")
                else
                    broadcastToAll("Script already exists on '" .. dropped_object.getName() .. "'. No changes made.")
                end
            elseif panel_orientation == "upside down" then
                -- This is the "Remove" side. Remove the script if it exists.
                local current_script = dropped_object.getLuaScript()

                -- Only update the script if it contained the dnd-marker script.
                if current_script:find(SCRIPT_IDENTIFIER, 1, true) then
					dropped_object.script_state = ""
					dropped_object.script_code = ""
					dropped_object.setLuaScript("")
					dropped_object.reload()
                    broadcastToAll("Script removed from '" .. dropped_object.getName() .. "'!")
                else
                    broadcastToAll("No script to remove from '" .. dropped_object.getName() .. "'.")
                end
            end
        else
            -- An object that is not a miniature was dropped. Report its type.
            print("An object of type '" .. dropped_object.type .. "' was dropped on the panel. No action taken.")
        end
    end
end
