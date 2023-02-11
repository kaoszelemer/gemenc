local FieldItem = Class('FieldItem')


function FieldItem:init(x,y,w,h,image, type)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.image = image
    self.type = type
end


return FieldItem