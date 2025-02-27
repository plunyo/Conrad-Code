local Timer = {}

function Timer.new(duration, callback, oneShot)
    local timerInstance = {}
    local initialDuration = duration
    local remainingTime = duration
    local isExpired = false
    local isRunning = false
    local isOneShot = oneShot or false

    function timerInstance.update(dt)
        if isRunning then
            remainingTime = remainingTime - dt

            if remainingTime <= 0 then
                if not isExpired then
                    isExpired = true
                    callback()
                    
                    if isOneShot then
                        timerInstance.stop()
                    end
                end
            end
        end
    end

    function timerInstance.isTimedOut()
        return isExpired
    end

    function timerInstance.reset()
        remainingTime = initialDuration
        isExpired = false
    end

    function timerInstance.start()
        if not isRunning then
            isRunning = true
            remainingTime = initialDuration
            isExpired = false
        end
    end

    function timerInstance.stop()
        isRunning = false
        remainingTime = initialDuration
        isExpired = false
    end

    function timerInstance.fire()
        if isOneShot then
            timerInstance.stop()
        end

        isExpired = false
        callback()
    end

    return timerInstance
end

return Timer
