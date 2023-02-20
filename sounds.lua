
local sources = {

    bulletsource = love.audio.newSource('assets/sounds/bullet.wav', 'static'),
    biodeathsource = love.audio.newSource('assets/sounds/biodeath.mp3', 'static'),
    cantdosource = love.audio.newSource('assets/sounds/cantdo.wav', 'static'),
    changelevelsource = love.audio.newSource('assets/sounds/changelevel.wav', 'static'),
    deathscreamsource = love.audio.newSource('assets/sounds/deathscream.mp3', 'static'),
    drilltanksource = love.audio.newSource('assets/sounds/drilltank.wav', 'static'),
    explosource = love.audio.newSource('assets/sounds/explo.wav', 'static'),
    hurtsource = love.audio.newSource('assets/sounds/hurt.wav', 'static'),
    lvlupsource = love.audio.newSource('assets/sounds/lvlup.wav', 'static'),
    pickupsource = love.audio.newSource('assets/sounds/pickup.wav', 'static'),
    specialsource = love.audio.newSource('assets/sounds/special.wav', 'static'),
    blipsource = love.audio.newSource('assets/sounds/blip.wav', 'static'),
    freezebulletsource = love.audio.newSource('assets/sounds/freezebullet.wav', 'static'),
    
    --MUSIC

    bosssource = love.audio.newSource('assets/music/boss.mp3', 'static'),
    gamesource = love.audio.newSource('assets/music/game.mp3', 'static'),
    menusource = love.audio.newSource('assets/music/menu.mp3', 'static'),


}

local sounds = {

    bullet = Ripple.newSound(sources.bulletsource, {volume = 3}),
    biodeath = Ripple.newSound(sources.biodeathsource, {volume = 0.2}),
    cantdo = Ripple.newSound(sources.cantdosource),
    changelevel = Ripple.newSound(sources.changelevelsource),
    deathscream = Ripple.newSound(sources.deathscreamsource, {volume = 0.2}),
    drilltank = Ripple.newSound(sources.drilltanksource),
    explo = Ripple.newSound(sources.explosource),
    hurt = Ripple.newSound(sources.hurtsource),
    lvlup = Ripple.newSound(sources.lvlupsource),
    pickup = Ripple.newSound(sources.pickupsource),
    special = Ripple.newSound(sources.specialsource),
    blip = Ripple.newSound(sources.blipsource),
    freezebullet = Ripple.newSound(sources.freezebulletsource),

    -- MUSIC

    

    boss = Ripple.newSound(sources.bosssource, {volume = 0.4, loop = true}),
    game = Ripple.newSound(sources.gamesource, {volume = 0.2, loop = true}),
    menu = Ripple.newSound(sources.menusource, {volume = 0.2, loop = true}),

}

return sounds