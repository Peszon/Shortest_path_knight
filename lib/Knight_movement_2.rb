class Position
    attr_reader :coordinates, :possible_moves

    def self.generete_possible_moves(coordinates, height)
        return nil if height <= 0 ||coordinates.nil?

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

        possible_coordinates = (1..8).to_a
        all_possible_moves.map! do |move| 
            if possible_coordinates.include?(move.coordinates[0]) && possible_coordinates.include?(move.coordinates[1])
                move
            else
                nil
            end 
        end 

        all_possible_moves
    end

    def initialize(coordinates, height)
        @coordinates = coordinates
        @possible_moves = Position.generete_possible_moves(coordinates, height)
    end
end 

class Position_tree
    attr_reader :position

    def self.Shortest_path_knight(start_coordinates, end_coordinates)
        tree_array = Position_tree.create_tree_array(start_coordinates) 
        end_index = tree_array.index(end_coordinates)
        
        move_indexes = Position_tree.index_step_trace(end_index)
        move_coordinates = Position_tree.indexes_to_coordinates(move_indexes, tree_array) 

        Position_tree.display(move_coordinates)
    end

    def self.create_tree_array(start_coordinates)
        position_tree = Position_tree.new(start_coordinates, 7)
        tree_array = position_tree.level_order_array(299593)
    end

    def self.index_step_trace(end_index) #figures out the indexes of the steps from root to end position.
        level_intervals = [0, 8, 72, 584, 4680, 37448, 299592] #first 7 numbers of 8^1 - 1 + 8^2 - 1 ... 8^n - 1. between 0 and n are all the possible indexes at height n in the tree.
        indexes = [end_index]

        until indexes[0] < 1  
            n = -1
            while indexes[0] < level_intervals[n]
                n -= 1
            end

            if n == -7
                next_index = indexes[0] / 8.0
            elsif indexes[0] > 8 && indexes[0] < 16
                next_index = 1.0
            else 
                next_index = ((indexes[0] - level_intervals[n]) / 8.0) + level_intervals[n - 1] 
            end 

            indexes.unshift(Position_tree.smoothen_index(next_index))
        end 

        indexes
    end

    def self.smoothen_index(index) 
        if index < 1.0
            0 
        elsif index.to_s.split(".")[1] == "0"
            index.to_i 
        else
            index.to_i + 1
        end 
    end

    def self.indexes_to_coordinates(index_array, tree_array)
        coordinates_array = index_array.map do |index|
            tree_array[index]
        end

        coordinates_array
    end

    def self.display(coordinates_array)
        puts "you made it here in #{coordinates_array.length - 1} moves!"
        coordinates_array.each { |coordinates| p coordinates }
    end 

    def initialize(coordinates, height)
        @position = Position.new(coordinates, height)
    end 

    def level_order_array(length)
        queue = [@position]
        all_coordinates = []
        index = 0

        until index >= length
            if queue[0].nil? 
                all_coordinates << nil
                8.times do
                    queue << nil
                end
            elsif queue[0].possible_moves.nil?
                all_coordinates << queue[0].coordinates
                8.times do
                    queue << nil
                end
            else
                all_coordinates << queue[0].coordinates
                queue[0].possible_moves.each do |move|
                    queue << move
                end
            end 

            index += 1
            queue.shift
        end

        all_coordinates
    end
end

Position_tree.Shortest_path_knight([4,2],[7,5])