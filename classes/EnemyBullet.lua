local EnemyBullet = Class('EnemyBullet')

function EnemyBullet:init(x, y, targetx, targety, parent, w, h, velx, vely, speed, visible, type)
    self.x = x
    self.y = y
    self.targetx = targetx
    self.targety = targety
    self.parent = parent
    self.w = 2
    self.h = 2
    self.velx = 0
    self.vely = 0
    self.speed = 500
    self.visible = true
    self.type = "EnemyBullet"

    self.removed = false
    print(self, " added")
    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.maxbulletdistance = 25
    self.ox = x
    self.oy = y
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


function EnemyBullet:draw()

    if self.visible then

        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end

--debug purposes
--[[     if self.removed then
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end ]]

end


function EnemyBullet:update(dt)


    
 --   self.removed = false
    local angle = math.atan2(self.targety - self.y, self.targetx - self.x)
    self.velx = 50
    self.vely = 50

--  if self.velx > 0 or self.vely > 0 then
        self.velx = self.velx * math.cos(angle)
        self.vely = self.vely * math.sin(angle) 
  

        self.x = self.x + (self.velx) * dt
        self.y = self.y + (self.vely) * dt
  --  end

    
    
    
    if self.removed ~= true then
        local ax, ay, cols, len = mapWorld:move(self, self.x, self.y, EnemyBulletFilter)
        
       -- print(len)
      

        for i = 1, #cols do
           
            --   print(    cols[i].other.EnemyBulletshot)
            if cols[i].other.type == 2 then
                self.velx, self.vely = 0,0
                player.isHit = true
                player.particleSystem:start()
                Timer.after(0.4, function() 
                    player.particleSystem:stop() 
                    player:addBloodSplatters(self.x +4, self.y+4, 8)
                end)
                player.hp = player.hp - 1
                self.visible = false
                self.removed = true
                Timer.after(1, function()    self.parent.EnemyBulletshot = false 

                end)
                
                print(self, "  removed cos playerhit")
                mapWorld:remove(self)
                return
            end
            
         --   print(cols[i].other.type)
          --  print(cols[i].other.type, self.removed)
         if cols[i].other.type == 1 then
            self.velx, self.vely = 0,0
            self.visible = false
            self.removed = true
            Timer.after(1, function()    self.parent.EnemyBulletshot = false end)
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
            Timer.after(1, function()    self.parent.EnemyBulletshot = false end)
            print(self, "  removed cos stopped ")
            mapWorld:remove(self)
            return
        end
        
        local distance = math.sqrt((self.targetx - (self.x))^2 + (self.targety - (self.y))^2)
       -- print(distance, self.maxbulletdistance)
     
        if distance <= 1 and self.removed ~= true then
            self.visible = false
            self.removed = true
            Timer.after(1, function()    self.parent.EnemyBulletshot = false end)
            print(self, "  removed cos distance ")
            mapWorld:remove(self)
        end

       
   
 

    end

    
  

  --   print(self.removed)

      --  print(self.x, self.targetx, self.x == self.targetx)

end



return EnemyBullet