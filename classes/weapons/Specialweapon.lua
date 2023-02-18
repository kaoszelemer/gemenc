local Specialweapon = Weapon:extend('Specialweapon')

function Specialweapon:init()

    Weapon.init(
    self,
    player.x + 4,
    player.y,
    love.graphics.newImage("assets/pistol.png"),
    3
  
)


end



function Specialweapon:shoot(x, y)

    for i = 1, 16 do
        table.insert(BULLETS, SpecialBullet(player.x +4,player.y+4, x, y, player, i))
    end

end




return Specialweapon