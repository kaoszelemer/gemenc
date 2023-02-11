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
    self.type =  type

end



function  Character:draw()
  if self.visible then

    love.graphics.draw(self.image, self.x, self.y)
  end

  if self.isDead then
    love.graphics.draw(self.particleSystem, self.x, self.y)
  end
   --debug

  --  print(self.x, self.y)
end


function Character:action()


end

function Character:kill()
  print("kill")
  Timer.after(1, function() self.particleSystem:stop() end)
  self.isDead = true
  self.visible = false
  mapWorld:remove(self)

end


function  Character:updateWorld(dt)

    
    
end




return Character


