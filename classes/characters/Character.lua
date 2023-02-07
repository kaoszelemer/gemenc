local Character = Class('Character')


function Character:init(x, y, colliders, name, image, velx, vely, speed, friction)

    self.x = x
    self.y = y
    self.colliders = colliders
    self.name = name
    self.image = image
    self.velx = velx
    self.vely = vely
    self.speed = speed
    self.friction = friction

end



function  Character:draw()

    love.graphics.draw(self.image, self.x, self.y)

end

function  Character:updateWorld(dt)

    
    
end




return Character


