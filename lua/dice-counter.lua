local startDelay = 1
local updateFrequency = 0.5

function onLoad()
    timer = Wait.condition(
            function()
                setup()
                startdelaytimer()
            end,
            function()
                return self.getBoundsNormalized().size.y > 0.05
            end
    )
    timer = Wait.frames(function()
        setup()
    end, startDelay)
end

function setup()
    thickness = self.getBoundsNormalized().size.y
    self.createButton({
        label = "",
        click_function = "none",
        function_owner = self,
        position = { 0, thickness, 0.7 },
        rotation = { 0, 0, 0 },
        scale = { 0.3, 0.3, 0.3 },
        height = 0,
        width = 0,
        font_color = { 1, 1, 1 },
        font_size = 500
    })
end

function startdelaytimer()
    timer = Wait.frames(
            function()
                startupdatetimer()
            end,
            startDelay
    )
end

function startupdatetimer()
    timer = Wait.time(
            function()
                countDice()
            end,
            updateFrequency,
            -1 -- makes the timer repeat itself forever
    )
end

function countDice()
    local totalValue = 0
    local itemsOnMat = findItemsInBox()
    for _, entry in ipairs(itemsOnMat) do
        local dice = entry.hit_object
        if dice.type == "Dice" then
            totalValue = totalValue + dice.getRotationValue()
        end
    end
    self.editButton({ index = 0, label = totalValue, position = { 0, thickness, 0.7 } })
end

function findItemsInBox()
    local height = 4
    local pos = self.positionToWorld({ x = 0, y = height / 2, z = 0 })
    local rot = self.getRotation()

    local bounds = self.getBoundsNormalized()
    bounds.size.y = height

    return Physics.cast({
        origin = pos, orientation = rot, direction = { 0, 1, 0 }, type = 3,
        max_distance = 0, size = bounds.size, --debug=true
    })
end

function onDestroy()
    Wait.stop(timer)
end