local MusicPlayer = require("src.musicPlayer")

local songs = {
    ["squabble up"] = require("src.songs.squabble up.data"),
}

function love.load()
    MusicPlayer.currentSong = songs["squabble up"]
    MusicPlayer.Play()
    MusicPlayer
end

function love.draw(dt)
    -- draw cover
    local cover = MusicPlayer.currentSong.cover
    love.graphics.draw(
        cover,
        (love.graphics.getWidth() / 2) - (cover:getWidth() / 2),
        (love.graphics.getHeight() / 2) - (cover:getHeight() / 2)
    )
end

function love.keypressed(key)
    if key == "esc" then
        love.event.quit()
    end
end
