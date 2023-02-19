local MaxSpUp = FieldItem:extend('MaxSpUp')

function MaxSpUp:init(x, y)

    Card.init(
    self,
    x,
    y,
    157,
    286,
    love.graphics.newImage("assets/maxspup.png"),
    4
  
)


    self.visible = false

    self.tilex = math.floor(self.x / tileW)
    self.tiley = math.floor(self.y / tileH)
    self.ammoup = love.math.random(10,19)
    self.name = "MaxSpUp"

end

function MaxSpUp:action()
    player.maxsp = player.maxsp + 6
    player.splevel = player.splevel + 1
 
    gameState:changeState(gameState.states.countback)
end

return MaxSpUp