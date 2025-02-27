#pragma once

#include <functional>
#include <vector>

class Signal {
public:
    Signal(std::function<void()> callback);
    void Fire() const;
    void Connect(std::function<void()> callback);
private:
    std::vector<std::function<void()>> callbacks;
};