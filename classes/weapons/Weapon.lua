local Weapon = Class('Weapon')


function Weapon:init(x,y,image)
    self.x = x
    self.y = y
    self.image = image
end



function  Weapon:draw()
   
    love.graphics.draw(self.image, self.x, self.y, self.r)

end

function Weapon:update(dt)

    self.r = math.atan(MOUSEX - (player.x * 6), MOUSEY - (player.y * 6) )
    self.x, self.y = player.x + 5, player.y

    print(player.x * 6, MOUSEX)
 
end





return Weapon