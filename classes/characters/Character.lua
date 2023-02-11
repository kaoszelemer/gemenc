local Character = Class('Character')


function Character:init(x, y, w,h,colliders, name, image, velx, vely, speed, friction, type)

    self.x = x
    self.y = y
    self.w = w
    self.h = h
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
   --debug

  --  print(self.x, self.y)
end


function Character:action()


end


function  Character:updateWorld(dt)

    
    
end




return Character


