local folderPath = "src/songs/squabble up/"

return {
    artist = "Kendrick Lamar",
    audio = love.audio.newSource(folderPath .. "audio.mp3", "static"),
    cover = love.graphics.newImage(folderPath .. "cover.jpg"),
}
