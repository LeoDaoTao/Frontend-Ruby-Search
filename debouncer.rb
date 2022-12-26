class Debouncer
  def initialize(delay, &block)
    @last_call = Time.now
    @delay = delay
    @block = block
  end

  def call(*args)
    Bowser.window.delay @delay do
      if Time.now - @last_call > @delay
        @block.call(*args)
        @last_call = Time.now
      end
    end
    @last_call = Time.now
  end
end
