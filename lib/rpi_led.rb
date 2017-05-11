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
  
  def dimmer_on()
    
    @pwm.start 0
    @pwm.frequency = 5
    @pwm.duty_cycle = 0.001
    sleep 0.5
    @pwm.frequency = 50
    sleep 0.2
    @pwm.duty_cycle = 0.006
    # dim
    @pwm.frequency = 70
    (0.125..1).step(0.06) do |x|
      @pwm.duty_cycle = x
      sleep 0.06
    end
    @pwm.frequency = 100

    # up to 10% duty cycle (bright)

    (1..10).step(0.125) do |x|
      @pwm.duty_cycle = x
      sleep 0.05
    end

    # up to 50% duty cycle (brighter)

    (10..50).step(0.125) do |x|
      @pwm.duty_cycle = x
      sleep 0.01
    end

    # up to 100% duty cycle (brightest)

    (50..100).step(0.25) do |x|
      @pwm.duty_cycle = x
      sleep 0.007
    end


    @pwm.duty_cycle = 100    
  end
  
  def dimmer_off()
    
    # up to 100% duty cycle (brightest)

    (50..100).step(0.25).to_a.reverse.each do |x|
      @pwm.duty_cycle = x
      sleep 0.006
    end


    # up to 50% duty cycle (brighter)

    (10..50).step(0.125).to_a.reverse.each do |x|
      @pwm.duty_cycle = x
      sleep 0.007
    end

    # up to 10% duty cycle (bright)

    (0.8..10).step(0.125).to_a.reverse.each do |x|
      @pwm.duty_cycle = x
      sleep 0.0085
    end

    @pwm.frequency = 40
    (0.125..0.8).step(0.06).to_a.reverse.each do |x|
      @pwm.duty_cycle = x
      sleep 0.006
    end
    @pwm.duty_cycle = 0.01
    @pwm.frequency = 10
    sleep 1.0
    @pwm.stop
  end  
end