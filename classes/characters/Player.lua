local Player = Character:extend('Player')

function Player:init(x, y)

    Character.init(
    self,
    x,
    y,
    8,
    8,
    {
        name = "gemenc",
        x = x,
        y = y,
        w = 8,
        h = 8
    },
    "soldier",
    love.graphics.newImage("assets/player.png"),
    0,
    0,
    500,
    10,
    2 -- type

)
self.tx = math.floor(self.x / 16)
self.ty = math.floor(self.y / 16)

  mapWorld:add(self, self.x, self.y, self.colliders.w, self.colliders.h)
  self.visible = true

  self.hp = 10
end

local function playerFilter(item, other)
   
    if other.type == 1 then
        return "slide"
    elseif other.type == "enemy" then
        return "bounce"
    elseif other.type == 4 then
        return "cross"
    else
        return nil   
    end
end


function Player:update(dt)
    self.tx = math.floor(self.x / 16)
    self.ty = math.floor(self.y / 16)
end


function Player:physics(dt)
    self.x = self.x + self.velx * dt
	self.y = self.y + self.vely * dt

	self.velx = self.velx * (1 - math.min(dt*self.friction, 1))
	self.vely = self.vely * (1 - math.min(dt*self.friction, 1))

end


function Player:move(dt)

    
    if love.keyboard.isDown("d") and
	self.velx < self.speed then
		self.velx = self.velx + self.speed * dt
	end
    
	if love.keyboard.isDown("a") and
	self.velx > -self.speed then
		self.velx = self.velx - self.speed * dt
	end
    
	if love.keyboard.isDown("s") and
	self.vely < self.speed then
		self.vely = self.vely + self.speed * dt
	end
    
	if love.keyboard.isDown("w") and
	self.vely > -self.speed then
		self.vely = self.vely - self.speed * dt
	end
    
    local ax, ay, cols, len = mapWorld:move(self, self.x , self.y, playerFilter)
 
    self.x = ax
    self.y = ay
  --  mapWorld:update(self, self.cx, self.cy)
    for i = 1, #cols do


        if len == 1 and cols[i].other.type ~= 4 then
            print(cols[i].other)
            self.velx, self.vely = 0,0
        end
        
        if cols[i].other.type == 4 then
            cols[i].other:action()
        end

    end

    --self.x, self.y = newx, newy
    
   

    
   player.fov:compute(math.floor((self.x - 4) / 16), math.floor((self.y -4) / 16), 4, computeCalbak)


end


function Player:action(x,y)

    if self.munition > 0 then
        self.munition = self.munition - 1
        INVENTORY[1]:shoot(x,y)
    end

end



return Player