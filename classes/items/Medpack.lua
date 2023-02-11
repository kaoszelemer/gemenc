local Medpack = FieldItem:extend('Medpack')

function Medpack:init(x, y)

    FieldItem.init(
    self,
    x,
    y,
    16,
    16,
    love.graphics.newImage("assets/medpack.png"),
    4
  
)

    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.visible = true
end



function Medpack:draw()

    if self.visible then
        love.graphics.draw(self.image, self.x, self.y)
    end


end

function Medpack:action()

    self.visible = false


end

return Medpack