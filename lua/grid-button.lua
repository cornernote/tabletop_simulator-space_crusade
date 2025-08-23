function onLoad()
    createGridButton()
end

modes   = {"Off","Lines","Center","Both"}
current = 1

function createGridButton()
    self.createButton({
        click_function = "toggleGrid",
        function_owner = self,
        label          = modes[Grid.snapping],
        position       = {0, 0, 2},
        height         = 400,
        width          = 1200,
        font_size      = 120,
    })
end

function toggleGrid()
    current = current % #modes + 1
    Grid.snapping   = current
    Grid.show_lines = (current ~= 1)
    --Grid.sizeX = 1.51
    --Grid.sizeY = 1.51

    self.editButton({ index = 2, label = modes[current] })
end
