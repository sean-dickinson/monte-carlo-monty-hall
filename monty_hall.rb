class MontyHall

  def initialize
    set_doors
    @selected_door = nil
  end

  def pick
    @selected_door = door_numbers.sample
  end

  def reveal_goat
    goat_door_number = unselected_doors.find {|n| reveal_door(n) == "goat"}
    remove_door(goat_door_number)
  end

  def switch_pick
    @selected_door = unselected_doors.first
  end

  def reveal_selected_door
    reveal_door(@selected_door)
  end

  private

  def set_doors
    @doors = {}
    %w[goat goat car].shuffle.each_with_index do |item, i|
      @doors[i] = item
    end
  end

  def door_numbers
    @doors.keys
  end

  def unselected_doors
    @doors.keys - [@selected_door]
  end

  def remove_door(number)
    @doors.delete(number)
  end

  def reveal_door(number)
    @doors[number]
  end
end

class Results
  def initialize(heading, results)
    @heading = heading
    @results = results
  end

  def print
    puts @heading
    @results.tally.each do |result, count|
      puts "#{result}: #{get_percentage(count)}%"
    end
  end

  private
  
  def get_percentage(count)
    p = (count.to_f / @results.size) * 100
    p.round(2)
  end
end


def spacer
  puts
  puts "-" * 30
  puts
end

ITERATIONS = 100_000

# First prove that the chance of getting a car is 1/3
one_pick_results = []
ITERATIONS.times do
  hall = MontyHall.new
  hall.pick
  one_pick_results << hall.reveal_selected_door
end

puts

Results.new("Results from single pick",one_pick_results).print

spacer

# Now show the results when you switch
switch_pick_results = []
ITERATIONS.times do
  hall = MontyHall.new
  hall.pick
  hall.reveal_goat
  hall.switch_pick
  switch_pick_results << hall.reveal_selected_door
end

Results.new("Results from switching after a goat is revealed", switch_pick_results).print