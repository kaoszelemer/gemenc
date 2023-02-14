local Pistol = Weapon:extend('Pistol')

function Pistol:init()

    Weapon.init(
    self,
    player.x + 4,
    player.y,
    love.graphics.newImage("assets/pistol.png"),
    3
  
)


end



function Pistol:shoot(x, y)

        table.insert(BULLETS, Bullet(self.x,self.y, x, y, player))


end




return Pistol