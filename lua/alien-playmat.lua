function onLoad()
    self.createButton({
        click_function = "null",
        function_owner = self,
        label = "Blip Tokens",
        position = { -2.1, 0.5, -1 },
        rotation = { 280, 0, 0 },
        color = { 0.1, 0.1, 0.1, 1 },
        font_color = { 1, 1, 1, 1 },
        scale = { 1, 1, 1.8 },
        width = 0,
        height = 0,
        font_size = 100,
    })
    self.createButton({
        click_function = "null",
        function_owner = self,
        label = "Reinforcement Tokens",
        position = { 1.5, 0.5, -1 },
        rotation = { 280, 0, 0 },
        color = { 0.1, 0.1, 0.1, 1 },
        font_color = { 1, 1, 1, 1 },
        scale = { 1, 1, 1.8 },
        width = 0,
        height = 0,
        font_size = 100,
    })
end
