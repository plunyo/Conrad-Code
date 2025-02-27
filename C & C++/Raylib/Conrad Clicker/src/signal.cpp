#include "signal.h"

Signal::Signal(std::function<void()> callback) {
    callbacks.push_back(callback);
}

void Signal::Fire() const {
    for (const std::function<void()>& callback : callbacks) {
        callback();
    }
}

void Signal::Connect(std::function<void()> callback) {
    callbacks.push_back(callback);
}