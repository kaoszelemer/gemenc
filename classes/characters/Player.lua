local Player = Character:extend('Player')

function Player:init(x, y)

    Character.init(
    self,
    x,
    y,
    {
        name = "abi",
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
    10

)

  mapWorld:add(self, self.colliders.x, self.colliders.y, self.colliders.w, self.colliders.h)

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

    local actualX, actualY, cols, len = mapWorld:move(self, self.x, self.y)
    self.x, self.y = actualX, actualY
    
   

    
   player.fov:compute(math.floor((self.x - 4) / 16), math.floor((self.y -4) / 16), 4, computeCalbak)
  --  player.fov:compute(player.x , player.y , 10, computeCalbak)

end



return Player