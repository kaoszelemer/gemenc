local EnemyBullet = Class('EnemyBullet')

function EnemyBullet:init(x, y, targetx, targety, parent, w, h, speed, velx, vely, visible, type)
    self.x = x
    self.y = y
    self.targetx = targetx
    self.targety = targety
    self.parent = parent
    self.w = 1
    self.h = 1
    self.velx = 1
    self.vely = 1
    self.visible = true
    self.type = "EnemyBullet"

    self.removed = false
    print(self, " added")
    mapWorld:add(self, self.x, self.y, self.w, self.h)

end

local function EnemyBulletFilter(item, other)
    if item.parent == other.parent then return nil end
    if other.type == 3 then
        
        return nil
    
    elseif other.type == 1 or other.type == 2 then

        return "touch"
    else return nil
    end
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


    if self.removed ~= true then
        self.removed = false
        local angle = math.atan2(self.targety - self.y, self.targetx - self.x)
        self.velx = math.floor(200 * math.cos(angle))
        self.vely = math.floor(200 * math.sin(angle))
        self.x = self.x + self.velx * dt
        self.y = self.y + self.vely * dt

        local _, _, cols, len = mapWorld:move(self, self.x, self.y, EnemyBulletFilter)
        for i = 1, #cols do
            print(    cols[i].other.EnemyBulletshot)
            if cols[i].other.type == 2 then
                player.hp = player.hp - 1
                self.visible = false
                self.removed = true
                Timer.after(1, function()    self.parent.EnemyBulletshot = false end)
             
                print(self, "  removed cos playerhit")
                mapWorld:remove(self)
            end
                
           

            
            if len == 1 and cols[i].other.type == 1 and self.removed == false then
                
                self.visible = false
                self.removed = true
                Timer.after(1, function()    self.parent.EnemyBulletshot = false end)
                print(self, "  removed cos wallhit")
                mapWorld:remove(self)
                return
            end
            
            
            
            
            
        end
        
        local distance = math.sqrt((self.x - player.x)^2 + (self.y - player.y)^2)
        
        if distance <= 1 and self.removed ==false then
            self.visible = false
            self.removed = true
            self.parent.EnemyBulletshot = false
            print(self, "  removed cos distance")
            mapWorld:remove(self)
            return
        end


    end

    
  

    -- print(self.removed)

      --  print(self.x, self.targetx, self.x == self.targetx)

end



return EnemyBullet