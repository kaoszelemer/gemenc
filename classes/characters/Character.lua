local Character = Class('Character')


function Character:init(x, y, w,h,colliders, name, image, velx, vely, speed, friction, type, rof, hp)

    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.colliders = colliders
    self.name = name
    self.image = image
    self.velx = velx
    self.vely = vely
    self.speed = speed
    self.friction = friction
    self.type =  type
    self.rof = rof
    self.hp = hp



      self.biobloodSplatterImage = love.graphics.newImage("assets/biobloodsplatter.png")

      self.bloodSplatterImage = love.graphics.newImage("assets/bloodsplatter.png")

    self.shadowimage = love.graphics.newImage("assets/shadow.png")
    self.shieldimage = love.graphics.newImage("assets/shield.png")

end

local bloodprints = {}


function  Character:draw()

if self.name ~= "Turret" or self.name ~= "Tank" or self.name ~= "spider" then
    for _, splatter in pairs(BLOODSPLATTERS) do
      love.graphics.draw(
          self.bloodSplatterImage,
          splatter.x,
          splatter.y,
          splatter.alpha,
          splatter.scale
      )
  end

  for k, v in ipairs(bloodprints) do

      love.graphics.setColor(1,1,1, v.alpha)
      love.graphics.draw(self.bloodSplatterImage, v.x + 4, v.y + 4, 0.75, 0.75)
      love.graphics.setColor(1,1,1, 1)
    
  end

end

if self.name == "spider" then
  for _, splatter in pairs(BLOODSPLATTERS) do
    love.graphics.draw(
        self.biobloodSplatterImage,
        splatter.x,
        splatter.y,
        splatter.alpha,
        splatter.scale
    )
end
end

if self.name == "gemenc" then
  
  love.graphics.setColor(1,1,1,0.2)
  love.graphics.draw(self.shadowimage, self.x + 6, self.y + 6, self.angle, nil, nil, 4, 4)
  love.graphics.setBlendMode("alpha")
  love.graphics.setColor(1,1,1,1)

  love.graphics.draw(self.smokeparticle, self.x, self.y, self.angle, nil, nil)

end
  if self.visible then

    love.graphics.draw(self.image, self.x + 4, self.y + 4, self.angle, nil, nil, 4, 4)
  end

  if self.shielded then
    love.graphics.draw(self.shieldimage, self.x -4, self.y-4)
  end

  if self.isDead or self.isHit then

    if self.name ~= "Turret" and self.name ~= "Tank" then
    love.graphics.draw(self.particleSystem, self.x + 4  , self.y + 4)
   
    else

    love.graphics.draw(self.particleSystem, self.x + 4, self.y + 4)
    love.graphics.draw(self.particleSystem, self.x + 8, self.y + 12)
    love.graphics.draw(self.particleSystem, self.x + 12, self.y + 8)
    love.graphics.draw(self.particleSystem, self.x + 16, self.y + 4)

    end
 
    
  end

  --debug

  if GLOBALS.drawenemycolliders then
    for i = 1, #ENEMIES do

    love.graphics.rectangle("line", ENEMIES[i].x, ENEMIES[i].y, ENEMIES[i].colliders.w, ENEMIES[i].colliders.h)
    end
  end


end

function Character:addBloodSplatters(x, y, times)
  if times == nil then times = 1 end
  for i = 1, times do
    local splatter = {
      x = x + love.math.random(-5,5),
      y = y + love.math.random(-5,5),
      scale = love.math.random(),
      
    }
    table.insert(BLOODSPLATTERS, splatter)
  end


    
  Timer.every(15, function() 
    table.remove(BLOODSPLATTERS, 1)
  end)
  
end

function  Character:addBloodPrints(x,y)
  

  if player.velx ~= 0 and player.vely ~= 0 then
  local bp = {
    x = x,
    y = y,
    age = 5,
    alpha = 1
  }

 -- print(x % 2)
--  if #bloodprints < 250 then
    if #bloodprints < 200 then
      if x % 2 >= 1.85 or y % 2 >= 1.85 then
        table.insert(bloodprints, bp)
      end
    end
 -- end
  end


 

end




function Character:action()


end

function Character:kill(pl)
  if pl == "pl" then
   
      gameState:changeState(gameState.states.gameover)
  
   
  elseif pl == "boss" then
    print("spwaning stairs")
    spawnStairs()




  end

  Timer.after(0.4, function() 
    self.particleSystem:stop()
    if self.name ~= "Turret" and self.name ~="Tank" and self.name ~= "bossrobot" then
      self:addBloodSplatters(self.x +4, self.y+4, 16)
    end
  end)
 

  self.isDead = true
  self.visible = false
  mapWorld:remove(self)



    for i = 1, #BULLETS do
 
      if BULLETS[i] ~= nil then
        if BULLETS[i].parent == self then  
          table.remove(BULLETS, i)
        end
      end
    end
  

end


function  Character:update(dt)
 
  for _, splatter in pairs(BLOODSPLATTERS) do
    
    self.distance = math.sqrt((splatter.x - (player.prevx))^2 + (splatter.y - (player.prevy))^2)
  --  print(self.distance)
    if self.distance < 4 and not player.standinblood then
      player.standinblood = true
    end
    if player.standinblood then
    
      player:addBloodPrints(player.x, player.y)
     
    end

    if self.distance > 27 then
      player.standinblood = false
    end
  end
  
 

  for i, splatter in ipairs(bloodprints) do
    local blooddecay = 25
    splatter.age = (splatter.age + dt) + 0.2
    splatter.alpha = (blooddecay - splatter.age) / blooddecay
  --print(splatter.alpha)
    --print(splatter.alpha)
    if splatter.alpha <= 0.1 then
       table.remove(bloodprints, i)
       
    end
  end

  if player.velX == 0 and player.velY == 0 then
    player.smokeparticle:stop()
  end




 
    
end




return Character


