local TankBullet = Class('TankBullet')

function TankBullet:init(x, y, targetx, targety, parent, num, w, h, velx, vely, speed, visible, type)
    self.x = x
    self.y = y
    self.targetx = targetx
    self.targety = targety
    self.parent = parent
    self.num = num
    self.w = 4
    self.h = 4
    self.velx = 0
    self.vely = 0
    self.speed = 40
    self.visible = true
    self.type = "TankBullet"


    self.removed = false
   -- print(self, " added")
    mapWorld:add(self, self.x, self.y, self.w, self.h)
 --   self.maxbulletdistance = 25
    self.ox = x
    self.oy = y
    self.rotationspeed = math.rad(360)

    if self.parent.name == "bossrobot" then
        self.angle = (math.pi / 4 * self.num) 
    else
        self.angle =  math.atan2(self.targety - self.y, self.targetx - self.x)
    end
end

local function EnemyBulletFilter(item, other)
  --  if item.parent:instanceOf(Enemy) then return nil end
    
    if other.type == 1 or other.type == 2 then
       -- print("tacs")
        return "touch"
    else 
    end

    return nil
end


function TankBullet:draw()

    if self.visible and self.parent.visible then
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end

end


function TankBullet:update(dt)

 

 --   self.removed = false
    if self.parent.name == "bossrobot" then
        local rspeed = math.pi / 1.2
        self.angle = self.angle + rspeed * dt
   
      
        self.velx = 400
        self.vely = 400

--  if self.velx > 0 or self.vely > 0 then

        self.velx = self.velx * math.cos(self.angle)
        self.vely = self.vely * math.sin(self.angle) 
  

        self.x = self.x + (self.velx) * dt
        self.y = self.y + (self.vely) * dt
       
    else
   
        self.velx = 50
        self.vely = 50

--  if self.velx > 0 or self.vely > 0 then

        self.velx = self.velx * math.cos(self.angle)
        self.vely = self.vely * math.sin(self.angle) 
  

        self.x = self.x + (self.velx) * dt
        self.y = self.y + (self.vely) * dt
    end
   
    
  --  end

    
    
    
    if self.removed ~= true then
        local ax, ay, cols, len = mapWorld:move(self, self.x, self.y, EnemyBulletFilter)
        
       -- print(len)
      

        for i = 1, #cols do
           
            --   print(    cols[i].other.EnemyBulletshot)
            if cols[i].other.type == 2 and not player.shielded then
                self.velx, self.vely = 0,0
                player.isHit = true
                if player.hp > 0 then
                    if player.hitinvi == false then
                        player.hp = player.hp - 2
                    end
                else
                    player:kill("pl")
                end
                player.hitinvi = true
                player.particleSystem:start()
                Timer.after(0.4, function() 
                    player.hitinvi = false
                    player.showhitinvi = false
                    player.particleSystem:stop() 
                end)
                screenShake(0.1, 3)
            
                self.visible = false
                self.removed = true
                Timer.after(self.parent.rof, function()    
                    if self.parent.name == "bossrobot" then 
                        self.parent.munition = self.parent.munition + 1
                    end
                    self.parent.EnemyBulletshot = false 

                end)
                
             --   print(self, "  removed cos playerhit")
                mapWorld:remove(self)
                return
            end
            
         --   print(cols[i].other.type)
          --  print(cols[i].other.type, self.removed)
         if cols[i].other.type == 1 then
            self.velx, self.vely = 0,0
            self.visible = false
            self.removed = true
            Timer.after(self.parent.rof, function()  
                if self.parent.name == "bossrobot" then 
                    self.parent.munition = self.parent.munition + 1
                end
                self.parent.EnemyBulletshot = false
             end)
             print(self, "  removed cos hit ")
            mapWorld:remove(self)
            return
         end
         
            
        --[[     if len >= 1 then
                self.visible = false
                self.removed = true
                Timer.after(1, function()    self.parent.EnemyBulletshot = false end)
                print(self, "  removed cos hit ")
                mapWorld:remove(self)
            end
             ]]
            
            
            
        end

        if self.velx == 0 and self.vely == 0 and self.removed ~= true then
         
            self.visible = false
            self.removed = true
            Timer.after(self.parent.rof, function()    
                if self.parent.name == "bossrobot" then 
                    self.parent.munition = self.parent.munition + 1
                end
                self.parent.EnemyBulletshot = false end)
            print(self, "  removed cos stopped ")
            mapWorld:remove(self)
            return
        end

        if self.parent.name == "Tank" then
        
            local distance = math.sqrt((self.targetx - (self.x))^2 + (self.targety - (self.y))^2)
      --   print(distance, self.maxbulletdistance)
        
            if distance <= 1 and self.removed ~= true then
                self.visible = false
                self.removed = true
                Timer.after(self.parent.rof, function()   
                    if self.parent.name == "bossrobot" then 
                        self.parent.munition = self.parent.munition + 1
                    end
                    self.parent.EnemyBulletshot = false end)
          print(self, "  removed cos distance ")
                mapWorld:remove(self)
            end

        end

        if self.parent.name == "bossrobot" then
            
        end

       
   
 

    end

    
  

  --   print(self.removed)

      --  print(self.x, self.targetx, self.x == self.targetx)

end



return TankBullet