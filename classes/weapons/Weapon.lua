local Weapon = Class('Weapon')


function Weapon:init(x,y,image, type)
    self.x = x
    self.y = y
    self.image = image
    self.type = type
end



function  Weapon:draw()
   
    love.graphics.draw(self.image, self.x + 5, self.y + 4, self.r)
  
end

function Weapon:update(dt)

    self.r = math.atan2(MOUSEY - (player.y) , MOUSEX - (player.x ))
    self.x, self.y = player.x, player.y

end





return Weapon