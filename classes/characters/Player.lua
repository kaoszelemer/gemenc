local Player = Character:extend('Player')

function Player:init(x, y)

    Character.init(
    self,
    x,
    y,
    {
        name = "abi",
        x = x,
        y = y,
        w = 8,
        h = 8
    },
    "soldier",
    love.graphics.newImage("assets/player.png")

)

    mapWorld:add(self, self.colliders.x, self.colliders.y, self.colliders.w, self.colliders.h)

end


return Player