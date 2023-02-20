local AlienEgg = Character:extend('AlienEgg')



function AlienEgg:init(x, y)

    Character.init(
    self,
    x,
    y,
    16,
    16,
    {
        name = "alienegg",
        x = x,
        y = y,
        w = 16,
        h = 16
    },
    "alienegg",
    love.graphics.newImage("assets/alienegg.png"),
    0,
    0,
    20,
    1,
    "egg", -- type
    0.1, --rof
    1
)

    mapWorld:add(self, self.x, self.y, self.colliders.w, self.colliders.h)
    self.visible = false
    self.tx = math.floor(self.x / tileW)
    self.ty = math.floor(self.y / tileH)
  
    self.xp = 0

    self.particleImage = love.graphics.newImage("assets/blood.png")
    self.particleSystem = love.graphics.newParticleSystem(self.particleImage, 32)
    self.particleSystem:setParticleLifetime(1, 1.5)
    self.particleSystem:setEmissionRate(32)
    self.particleSystem:setSizeVariation(1)
    self.particleSystem:setLinearAcceleration(-20, -20, 20, 20)
    self.particleSystem:setColors(145, 0, 0, 255, 145, 0, 0, 0)
    self.particleSystem:start()

    self.bloodSplatterImage = love.graphics.newImage("assets/bloodsplatter.png")

end



function AlienEgg:update(dt)
    local distance = math.sqrt((player.x - self.x)^2 + (player.y - self.y)^2)

    self.tx = math.floor(self.x / tileW)
    self.ty = math.floor(self.y / tileH)

    if (self.tx > 0 and self.tx <= maxX) and (self.ty > 0 and self.ty <= maxY) then
        if MAP[self.tx][self.ty].visible and not self.isDead then
            self.visible = true
        else
            self.visible = false
        end
    end


    if distance < 65 and not self.isDead then
        self:action(x, y)
    end

    if self.isDead then
        self.particleSystem:update(dt)
    end
    if self.x < tileW +2 then
      
        self.x = tileW+2
      end
      if self.y < tileH+2 then
   
        self.y = tileH+2
      end
      if self.x > ((maxX) * tileW) +4 then
      
        self.x = ((maxX) * tileW)+4
      end
      if self.y > ((maxY) * tileH)+4 then
    
        self.y = ((maxY) * tileH)+4
      end 
end

function AlienEgg:move(dt)


end

function AlienEgg:action(x,y)      
      
        

end


return AlienEgg