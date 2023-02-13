local Stairs = FieldItem:extend('Stairs')

function Stairs:init(x, y)

    FieldItem.init(
    self,
    x,
    y,
    16,
    16,
    love.graphics.newImage("assets/stairs.png"),
    4
  
)

    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.visible = false

    self.tilex = math.floor(self.x / self.w)
    self.tiley = math.floor(self.y / self.h)

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
    --[[ if not self.standingonStairs then
        player.standingonStairs = true
        Timer.after(5, function ()
            player.standingonStairs = false
        end) ]]
     
        if love.keyboard.isDown("space") and player.changinglevel ~= true then
            player.changinglevel = true
            changeLevel()
        end      
--    end
end


return Stairs