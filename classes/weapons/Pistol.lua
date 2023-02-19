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

        player.munition = player.munition - 1
        table.insert(BULLETS, Bullet(self.x +4,self.y+4, x, y, player))

end




return Pistol