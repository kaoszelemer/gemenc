local MaxHpUp = FieldItem:extend('MaxHpUp')

function MaxHpUp:init(x, y)

    Card.init(
    self,
    x,
    y,
    157,
    286,
    love.graphics.newImage("assets/maxhpup.png"),
    4
  
)

 
    self.visible = false

    self.tilex = math.floor(self.x / tileW)
    self.tiley = math.floor(self.y / tileH)
    self.ammoup = love.math.random(10,19)
    self.name = "MaxHpUp"

end


function MaxHpUp:action()
    player.maxhp = player.maxhp + 5
    player.hplevel = player.hplevel + 1
    gameState:changeState(gameState.states.countback)
end

return MaxHpUp
