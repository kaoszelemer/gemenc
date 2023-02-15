local Turret = Character:extend('Turret')



function Turret:init(x, y)

    Character.init(
    self,
    x,
    y,
    16,
    16,
    {
        name = "turret",
        x = x,
        y = y,
        w = 16,
        h = 16
    },
    "Turret",
    love.graphics.newImage("assets/turret.png"),
    0,
    0,
    20,
    1,
    "enemy", -- type
    0.1, --rof
    1
)

    mapWorld:add(self, self.x, self.y, self.colliders.w, self.colliders.h)
    self.visible = false
    self.tx = math.floor(self.x / tileW)
    self.ty = math.floor(self.y / tileH)
  


    self.particleImage = love.graphics.newImage("assets/exploparticle.png")
    self.particleSystem = love.graphics.newParticleSystem(self.particleImage, 32)
    self.particleSystem:setParticleLifetime(0.8, 1.8)
    self.particleSystem:setEmissionRate(64)
    self.particleSystem:setLinearAcceleration(-15, -15, 15, 15)
    self.particleSystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    self.particleSystem:setSizes(2, 0)
    self.particleSystem:start()

end



function Turret:update(dt)
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
    if self.x < 18 then
   
        self.x = 18
      end
      if self.y < 18 then
  
        self.y = 18
      end
      if self.x > ((maxX) * tileW) +4 then
      
        self.x = ((maxX) * tileW)+4
      end
      if self.y > ((maxY) * tileH)+4 then
    
        self.y = ((maxY) * tileH)+4
      end 
end

function Turret:move(dt)


end

function Turret:action(x,y)

   
        if self.EnemyBulletshot ~= true then
        
            table.insert(BULLETS, EnemyBullet(self.x + self.colliders.w / 2,self.y + self.colliders.h / 2, player.x, player.y, self))
            self.EnemyBulletshot = true
        end
        
      
        

end


return Turret