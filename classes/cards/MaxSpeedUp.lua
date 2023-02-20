local MaxSpeedUp = FieldItem:extend('MaxSpeedUp')

function MaxSpeedUp:init(x, y)

    Card.init(
    self,
    x,
    y,
    157,
    286,
    love.graphics.newImage("assets/maxspeedup.png"),
    4
  
)


    self.visible = false

    self.tilex = math.floor(self.x / tileW)
    self.tiley = math.floor(self.y / tileH)
    self.ammoup = love.math.random(10,19)
    self.name = "MaxSpeedUp"

end

function MaxSpeedUp:action()
    player.speed = player.speed + 30
   
    gameState:changeState(gameState.states.countback)
end

return MaxSpeedUp