local Spider = Character:extend('Spider')



function Spider:init(x, y)

    Character.init(
    self,
    x,
    y,
    16,
    16,
    {
        name = "spider",
        x = x,
        y = y,
        w = 16,
        h = 16
    },
    "spider",
    love.graphics.newImage("assets/spider.png"),
    love.math.random(40,60),
    love.math.random(40,60),
    20,
    1,
    "enemy" ,-- type
    1, --rof
    1 --hp
)

  mapWorld:add(self, self.x, self.y, self.colliders.w, self.colliders.h)
  self.visible = false
  self.tx = math.floor(self.x / tileW)
  self.ty = math.floor(self.y / tileH)
    self.ox = self.x
    self.direction = 1
    self.walkdistance = love.math.random(1,15)
    self.angle = 0
    self.xp = 1

    self.particleImage = love.graphics.newImage("assets/bioblood.png")
    self.particleSystem = love.graphics.newParticleSystem(self.particleImage, 32)
    self.particleSystem:setParticleLifetime(1.5, 1.5)
    self.particleSystem:setEmissionRate(32)
    self.particleSystem:setSizeVariation(1)
    self.particleSystem:setLinearAcceleration(-20, -20, 20, 20)
    self.particleSystem:setColors(145, 0, 0, 255, 145, 0, 0, 0)
    self.particleSystem:start()

    self.bloodSplatterImage = love.graphics.newImage("assets/biobloodsplatter.png")

    if LEVEL == GLOBALS.bossonwhichlevel * 2 then
       self.velx = 80
       self.vely = 80
    end

end



local function enemyFilter(item, other)
 
    if other.type == 1 or other.type == 2 then
        return "bounce"
    else
        return nil   
    end
end



function Spider:update(dt)
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

    if LEVEL == GLOBALS.bossonwhichlevel * 2 then
        distance = 0
    end

    if distance < 45 and not self.isDead then
        self.canMove = true
    else
        
        self.canMove = false
    end

    if self.isDead then
        self.particleSystem:update(dt)
    end
    if self.x < tileW +2 then
        self.direction = -self.direction
        self.x = tileW+2
      end
      if self.y < tileH+2 then
        self.direction = -self.direction
        self.y = tileH+2
      end
      if self.x > ((maxX) * tileW) +4 then
        self.direction = -self.direction
        self.x = ((maxX) * tileW)+4
      end
      if self.y > ((maxY) * tileH)+4 then
        self.direction = -self.direction
        self.y = ((maxY) * tileH)+4
      end 

end

function Spider:move(dt)



  if not self.isDead and self.canMove then

        local fX, fY = self.x, self.y

        local dx = player.x - self.x
        local dy = player.y - self.y

        local angle = math.atan2(dy, dx)

        local fx = self.x + (self.velx * dt) * math.cos(angle) * self.direction
        local fy = self.y + (self.vely * dt) * math.sin(angle) * self.direction
        
            
        local ax, ay, cols, len = mapWorld:move(self, fx , fy, enemyFilter)
        
        self.x = ax
        self.y = ay

      --[[   if len == 0 then
            self.speed = 20
        end ]]
        --  mapWorld:update(self, self.cx, self.cy)
        for i = 1, #cols do

          
                if cols[i].other.name == player.name and not player.hitinvi and not player.shielded then
                    cols[i].other.hp = cols[i].other.hp - 1
                    --    screenShake(0.1, 3)
                        self.direction = -self.direction
                        if cols[i].other.hp <= 0 then
                      
                                cols[i].other:kill("pl")
                                
                        else
                    
                            cols[i].other.hitinvi = true
                            cols[i].other.particleSystem:start()
                            Timer.after(0.4, function() 
                                cols[i].other.particleSystem:stop()
                                cols[i].other.hitinvi = false
                                cols[i].other.showhitinvi = false
                               
                            end)
                            Timer.after(0.15, function()
                                self.direction = -self.direction
                            end)
                        end
                end
        end
            
        
 


    end
end

function Spider:action(x,y)

   
      --[[   if self.EnemyBulletshot ~= true then
        
            table.insert(BULLETS, EnemyBullet(self.x + self.colliders.w / 2,self.y + self.colliders.h / 2, player.x, player.y, self))
            self.EnemyBulletshot = true
        end ]]
        
      
        

end


return Spider