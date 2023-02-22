local SniperBullet = Class('SniperBullet')

function SniperBullet:init(x, y, targetx, targety, parent, num, w, h, velx, vely, speed, visible, type)
    self.x = x
    self.y = y
    self.targetx = targetx
    self.targety = targety
    self.parent = parent
    self.num = num
    self.w = 2
    self.h = 2
    self.velx = 0
    self.vely = 0
    self.speed = 500
    self.visible = true
    self.type = "EnemyBullet"


    self.removed = false
   -- print(self, " added")
    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.maxbulletdistance = 25
    self.ox = x
    self.oy = y
    if self.parent.name == "commando" then
        
        self.angle =  math.atan2(self.targety - self.y, self.targetx - self.x)
        if self.num ~= 0 then
            self.angle = self.angle + math.rad(self.num)
        end
  
    else
        self.angle =  math.atan2(self.targety - self.y, self.targetx - self.x)
    end

    
end

local function EnemyBulletFilter(item, other)
  --  if item.parent:instanceOf(Enemy) then return nil end
    
    if other.type == 2 or other.type == "egg" then
       -- print("tacs")
        return "touch"
    else 
    end

    return nil
end


function SniperBullet:draw()

    if self.visible and self.parent.visible then
        love.graphics.setColor(COLORS.sniperred)
        love.graphics.rectangle("line", self.x-1,self.y-1, self.w+2,self.h+2)
        love.graphics.setColor(COLORS.lightgreen)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
        love.graphics.setColor(1,1,1)
    end

end


function SniperBullet:update(dt)


    
 --   self.removed = false
   -- local angle = math.atan2(self.targety - self.y, self.targetx - self.x)
    self.velx = 50
    self.vely = 50
    if self.parent.name == "sniper" then
        self.velx = 180
        self.vely = 180
    end
--  if self.velx > 0 or self.vely > 0 then
        self.velx = self.velx * math.cos(self.angle)
        self.vely = self.vely * math.sin(self.angle) 
  

        self.x = self.x + (self.velx) * dt
        self.y = self.y + (self.vely) * dt
  --  end

    
    
    
    if self.removed ~= true then
        local ax, ay, cols, len = mapWorld:move(self, self.x, self.y, EnemyBulletFilter)
        
       -- print(len)
      

        for i = 1, #cols do

            if cols[i].other.type == "egg" then
                cols[i].other:kill(cols[i].other)
                self.velx, self.vely = 0,0
                self.visible = false
                self.removed = true
                if self.parent.name == "commando" then
                    self.parent.munition = self.parent.munition +1
                end
                Timer.after(self.parent.rof, function()   
                     self.parent.EnemyBulletshot = false 
                     if self.parent.name == "bossrobot" or self.parent.name == "bossrefrig" then
                        self.parent.simplemun = self.parent.simplemun + 1
                        self.parent.SimpleEnemyBulletshot = false
                    end
                    end)
             --   print(self, "  removed cos hit ")
                mapWorld:remove(self)
                return
            end
           
            --   print(    cols[i].other.EnemyBulletshot)
            if cols[i].other.type == 2 and not player.shielded then
                self.velx, self.vely = 0,0
                player.isHit = true
                if player.hp > 0 then
                    if player.hitinvi == false then
                        local instance = SOUNDS.hurt:play()
                        if self.parent.name ~= "sniper" then
                            player.hp = player.hp - 1
                        else
                            player.hp = player.hp - 5
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
                if self.parent.name == "commando" then
                    self.parent.munition = self.parent.munition +1
                end
                Timer.after(self.parent.rof, function()   
                     self.parent.EnemyBulletshot = false 
                    if self.parent.name == "bossrobot" or self.parent.name == "bossrefrig" then
                        self.parent.simplemun = self.parent.simplemun + 1
                        self.parent.SimpleEnemyBulletshot = false
                    end
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
            if self.parent.name == "commando" then
                self.parent.munition = self.parent.munition +1
            end
            Timer.after(self.parent.rof, function()   
                 self.parent.EnemyBulletshot = false 
                 if self.parent.name == "bossrobot" or self.parent.name == "bossrefrig" then
                    self.parent.simplemun = self.parent.simplemun + 1
                    self.parent.SimpleEnemyBulletshot = false
                end
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
            if self.parent.name == "commando" then
                self.parent.munition = self.parent.munition +1
            end
            Timer.after(self.parent.rof, function()   
                 self.parent.EnemyBulletshot = false 
                
                 if self.parent.name == "bossrobot" or self.parent.name == "bossrefrig" then
                    self.parent.simplemun = self.parent.simplemun + 1
                    self.parent.SimpleEnemyBulletshot = false
                end
                
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
            if self.parent.name == "commando" then

                self.parent.munition = self.parent.munition +1
            end
            Timer.after(self.parent.rof, function()    
                self.parent.EnemyBulletshot = false 
                  if self.parent.name == "bossrobot" or self.parent.name == "bossrefrig" then
                        self.parent.simplemun = self.parent.simplemun + 1
                        self.parent.SimpleEnemyBulletshot = false
                    end
            end)
         --   print(self, "  removed cos distance ")
            mapWorld:remove(self)
        end

       
   
 

    end

    
  

  --   print(self.removed)

      --  print(self.x, self.targetx, self.x == self.targetx)

end



return SniperBullet