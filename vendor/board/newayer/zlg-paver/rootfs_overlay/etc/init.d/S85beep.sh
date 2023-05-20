#!/bin/sh

# ring beep
echo 60 > /sys/class/leds/beeper-pwm/brightness
usleep 200000
echo 0 > /sys/class/leds/beeper-pwm/brightness

