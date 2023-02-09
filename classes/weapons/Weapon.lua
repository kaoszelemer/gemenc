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

--[[ 
    local w = 800 / player.camera.scale
    local h = 600 / player.camera.scale ]]

    self.r = math.atan2(MOUSEY - (player.y) , MOUSEX - (player.x ))
    self.x, self.y = player.x + 4, player.y + 4
    
  -- print("mm"..MOUSEX, MOUSEY)
 
end





return Weapon