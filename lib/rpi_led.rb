#!/usr/bin/env ruby

# file: rpi_led.rb

require 'rpi_pwm'


class RPiLed < RPiPwm


  attr_accessor :brightness

  def initialize(pin_num, brightness: 100, smooth: true, transition_time: 1.5)

    @smooth, @transition_time = smooth, transition_time
    super(pin_num.to_i, duty_cycle: brightness)
    @brightness = @duty_cycle

  end

  def brighter()

    return if @brightness == 100
    increase = @brightness <= 90 ? 10 : 100 - @brightness
    self.brightness = @brightness + increase
    
  end

  def brightest()
    self.brightness = 100
  end

  def brightness=(val)
    
    @brightness = val.round(2)

    return self.duty_cycle = val  unless @smooth

    a = if val > @duty_cycle then
      (@duty_cycle..val).step(0.01).to_a
    else
      (val..@duty_cycle).step(0.01).to_a.reverse
    end

    duration = @transition_time / a.length
    Thread.new { a.each {|x| self.duty_cycle = x; sleep duration } }
    

  end

  alias bright brightness

  def dimmer()

    return if @brightness <= 2
    decrease = brightness > 10 ? 10 : 2
    self.brightness = @brightness - decrease

  end

  def dimmest()
    self.brightness = 0.1
  end
end