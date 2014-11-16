#!/usr/bin/ruby

require 'pi_piper' # for PiPiper
require 'thread'   # for Queue

DELAY=3

# queue for events
queue=Queue.new

# monitor GPIO 17 pin
PiPiper.watch :pin=>17, :trigger=>:both do |pin|
  event=[Time.now, pin.on?]
  queue << event
end

# LED control thread
Thread.new do
  # initialize GPIO 27 pin
  pin=PiPiper::Pin.new :pin=>27, :direction=>:out
  loop {
    event=queue.pop

    t=event[0]
    s=event[1]

    tts=t+DELAY-Time.now
    sleep tts if tts>0 # waits tts sec if needed

    # LED on/off
    pin.update_value s
  }
end

PiPiper.wait # blocks the main thread
