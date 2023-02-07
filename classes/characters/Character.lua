local Character = Class('Character')


function Character:init(x, y, colliders, name, image)

    self.x = x
    self.y = y
    self.colliders = colliders
    self.name = name
    self.image = image

end



function  Character:draw()

    love.graphics.draw(self.image, self.x, self.y)

end

function  Character:updateWorld(dt)

    
    
end




return Character


