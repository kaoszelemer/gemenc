local Stairs = FieldItem:extend('Stairs')

function Stairs:init(x, y)

    FieldItem.init(
    self,
    x,
    y,
    32,
    32,
    love.graphics.newImage("assets/stairs.png"),
    4
  
)

    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.visible = false
    self.tilex = math.floor(self.x / tileW)
    self.tiley = math.floor(self.y / tileH)
end


function Stairs:updateVisibility()
          if MAP[self.tilex][self.tiley].visible and not self.pickedup then
              self.visible = true
          end

          if self.tilex == player.tx and self.tiley == player.ty then
            player.standingonStairs = true
          else
            player.standingonStairs = false
          end

         -- print(self.ty)
end


function Stairs:draw()

  if self.visible then
      love.graphics.draw(self.image, self.x, self.y)
  end




end

function Stairs:action()
     
        if love.keyboard.isDown("space") and player.changinglevel ~= true then
            gameState:changeState(gameState.states.trans)
            player.changinglevel = true
            local instance = SOUNDS.changelevel:play()
            Timer.after(0.8, function ()
              gameState:changeState(gameState.states.countback)
              changeLevel()
            end)
        end      

end


return Stairs