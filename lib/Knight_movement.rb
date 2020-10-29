class Position
    attr_reader :coordinates, :possible_moves

    def self.generete_possible_moves(coordinates, height)
        return nil if height <= 0
        return Array.new(8, nil) if coordinates.nil?

        cX = coordinates[0]
        cY = coordinates[1]
        all_possible_moves = [
                              Position.new([cX + 2, cY + 1], height - 1),
                              Position.new([cX + 2, cY - 1], height - 1),
                              Position.new([cX + 1, cY + 2], height - 1),
                              Position.new([cX + 1, cY - 2], height - 1),
                              Position.new([cX - 1, cY + 2], height - 1),
                              Position.new([cX - 1, cY - 2], height - 1),
                              Position.new([cX - 2, cY + 1], height - 1),
                              Position.new([cX - 2, cY - 1], height - 1)
                             ]

        possible_coordinates = (0..8).to_a
        all_possible_moves.map! { |move| nil unless 
                                possible_coordinates.include?(move.coordinates[0]) && 
                                possible_coordinates.include?(move.coordinates[1]) 
                                } 
        all_possible_moves
    end

    def initialize(coordinates, height)
        @coordinates = coordinates
        @possible_moves = Position.generete_possible_moves(coordinates, height)
    end
    
    def level_order_search(coordinates)
        queue = [self]
        all_coordinates = []

        puts "turkey"
        until coordinates == all_coordinates[-1] ||
            queue[-1].nil? ? all_coordinates << nil : all_coordinates << queue[-1].coordinates
            queue += self.possible_moves

            p all_coordinates[-1]
            donkey += 1
        end
        puts "donkey"

        all_coordinates.length
    end
end 

position = Position.new([1,1], 4)
p position.level_order_search([2,3])
p position.level_order_search([4,6])