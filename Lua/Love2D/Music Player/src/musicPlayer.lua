local MusicPlayer = {
    currentSong = nil,
}

function MusicPlayer.Play()
    love.audio.play(MusicPlayer.currentSong.audio)
end

function MusicPlayer.Pause()
    love.audio.pause(MusicPlayer.currentSong.audio)
end

return MusicPlayer
