local lilFreezeBullet = Class('lilFreezeBullet')

function lilFreezeBullet:init(x, y, targetx, targety, parent, num, w, h, velx, vely, speed, visible, type)
    self.x = x
    self.y = y
    self.targetx = targetx
    self.targety = targety
    self.parent = parent
    self.num = num
    self.w = 6
    self.h = 6
    self.velx = 0
    self.vely = 0
    self.speed = 500
    self.visible = true
    self.type = "lilFreezeBullet"


    self.removed = false
   -- print(self, " added")
    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.maxbulletdistance = 25
    self.ox = x
    self.oy = y
    self.image = love.graphics.newImage('assets/lilfreezebullet.png')

    
end

local function FreezeBulletFilter(item, other)
  --  if item.parent:instanceOf(Enemy) then return nil end
    
    if other.type == 1 or other.type == 2 then
       -- print("tacs")
        return "touch"
    else 
    end

    return nil
end


function lilFreezeBullet:draw()

    if self.visible and self.parent.visible then
       -- print("lofasy")
        love.graphics.draw(self.image, self.x, self.y)
    end

end


function lilFreezeBullet:update(dt)


    
 --   self.removed = false
   -- local angle = math.atan2(self.targety - self.y, self.targetx - self.x)
    self.velx = 40
    self.vely = 40

--  if self.velx > 0 or self.vely > 0 then
local angle = math.atan2(self.targety - self.y, self.targetx - self.x)
self.velx = self.velx * math.cos(angle)
self.vely = self.vely * math.sin(angle) 
self.x = self.x + self.velx * dt
self.y = self.y + self.vely * dt
  --  end

    
    
    
    if self.removed ~= true then
        local ax, ay, cols, len = mapWorld:move(self, self.x, self.y, FreezeBulletFilter)
        
       -- print(len)
      

        for i = 1, #cols do
            print(cols[i].other.type)
            --   print(    cols[i].other.EnemyBulletshot)
            if cols[i].other.type == 2 and not player.shielded then
                self.velx, self.vely = 0,0
                player.isHit = true
                if player.hp > 0 then
                    if player.hitinvi == false then
                        local instance = SOUNDS.hurt:play()
                        player.hp = player.hp - 1
                        if not player.frozen then
                            player.frozen = true
                            player.originalspeed = player.speed
                            player.speed = player.speed / 2

                            Timer.after(3.5, function() 
                               player.frozen = false
                               player.speed = player.originalspeed
                            end)
                        end
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
                    player:addBloodSplatters(self.x +4, self.y+4, 8)
                end)
                screenShake(0.1, 3)
            
                self.visible = false
                self.removed = true
             
                Timer.after(self.parent.rof, function()   
                
                  
                     
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
             
             
                
                   self.parent.EnemyBulletshot = false
                 
           end)
         --   print(self, "  removed cos hit ")
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
       
             
               
                   self.parent.EnemyBulletshot = false
           
           end)
       --     print(self, "  removed cos stopped ")
            mapWorld:remove(self)
            return
        end
        
        local distance = math.sqrt((self.targetx - (self.x))^2 + (self.targety - (self.y))^2)
       -- print(distance, self.maxbulletdistance)
     
        if distance <= 1 and self.removed ~= true then
            self.visible = false
            self.removed = true
            Timer.after(self.parent.rof, function()   
            
             
          
                   self.parent.EnemyBulletshot = false
           
           end)
         --   print(self, "  removed cos distance ")
            mapWorld:remove(self)
        end

       
   
 

    end

    
  

  --   print(self.removed)

      --  print(self.x, self.targetx, self.x == self.targetx)

end



return lilFreezeBullet