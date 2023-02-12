local Weapon = Class('Weapon')


function Weapon:init(x,y,image, type)
    self.x = x
    self.y = y
    self.image = image
    self.type = type
end



function  Weapon:draw()
   
    love.graphics.draw(self.image, self.x, self.y, self.r)
    
end

function Weapon:update(dt)

    self.r = math.atan2(MOUSEY - (player.y) , MOUSEX - (player.x ))
    self.x, self.y = player.x + 4, player.y + 4

end





return Weapon