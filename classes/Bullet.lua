local Bullet = Class('Bullet')

function Bullet:init(x, y, targetx, targety, parent, w, h, speed, velx, vely, visible, type)
    self.x = x
    self.y = y
    self.targetx = targetx
    self.targety = targety
    self.parent = parent
    self.w = 2
    self.h = 2
    self.velx = 50
    self.vely = 50
    self.visible = true
    self.type = "Bullet"
  

    self.removed = false
  --  print(self, " added")
    mapWorld:add(self, self.x, self.y, self.w, self.h)
    

end

local function bulletFilter(item, other)
    if other.type == 2 or other.type == 3 then
        
        return nil
    
    elseif other.type == 1 or other.type == "enemy" then

        return "touch"
    else return nil
    end
end


function Bullet:draw()

    if self.visible then

        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end

--debug purposes
--[[     if self.removed then
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end ]]

end


function Bullet:update(dt)


    if self.removed ~= true then
        self.removed = false
        local angle = math.atan2(self.targety - self.y, self.targetx - self.x)
        self.velx = math.floor(200 * math.cos(angle))
        self.vely = math.floor(200 * math.sin(angle))
        self.x = self.x + self.velx * dt
        self.y = self.y + self.vely * dt

        local _, _, cols, len = mapWorld:move(self, self.x, self.y, bulletFilter)
        for i = 1, #cols do
       --    print("type: "..cols[i].other.type)
            if cols[i].other.type == "enemy" and not cols[i].other.hitinvi then
                cols[i].other.hp = cols[i].other.hp - 1
            --   
            if cols[i].other.name == "bossspider" and cols[i].other.hp % 2 == 0 then
                cols[i].other:action()
            end


                
                if cols[i].other.hp <= 0 then
                    if cols[i].other.name == "bossrobot" or cols[i].other.name == "bossspider" then
                        screenShake(0.75, 3)
                        cols[i].other:kill(cols[i].other.name)
                    else
                        cols[i].other:kill()
                    end 
                self.visible = false
                self.removed = true
                player.bulletshot = false
                print(self, "  removed cos kill")
                mapWorld:remove(self)
                else
                    self.visible = false
                    self.removed = true
                    player.bulletshot = false
                    print(self, "  removed cos hit")
                    mapWorld:remove(self)
                    cols[i].other.hitinvi = true
                    cols[i].other.particleSystem:start()
                    Timer.after(0.1, function() 
                        cols[i].other.hitinvi = false
                        cols[i].other.showhitinvi = false
                    end)
                end
             
            end

            
                
           

            
            if len == 1 and cols[i].other.type == 1 and self.removed == false then
                
                self.visible = false
                self.removed = true
                player.bulletshot = false
                print(self, "  removed cos hit")
                mapWorld:remove(self)
                return
            end
            
            
            
            
            
        end
        if self.velx == 0 and self.vely == 0 and self.removed ~= true then
         
            self.visible = false
            self.removed = true
            Timer.after(0.3, function()    player.bulletshot = false end)
            print(self, "  removed cos stopped ")
            mapWorld:remove(self)
            return
        end
      --  local distance = math.sqrt((MOUSEX - self.x)^2 + (MOUSEY - self.y)^2)
        
        local distance1 = math.sqrt((player.x - (self.targetx))^2 + (player.y - (self.targety))^2)
        local distance2 = math.sqrt((player.x - (self.x))^2 + (player.y - (self.y))^2)
      
      
         if (distance1 - distance2)*1 <= 2 and self.removed ~= true then
             self.visible = false
             self.removed = true
            
           
             Timer.after(0.3, function()    player.bulletshot = false end)
             print(self, "  removed cos distance ")
             mapWorld:remove(self)
         end




    end

    
  

    -- print(self.removed)

      --  print(self.x, self.targetx, self.x == self.targetx)

end



return Bullet