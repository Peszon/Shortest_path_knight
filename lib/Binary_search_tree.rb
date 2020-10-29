class Node
	attr_accessor :value, :right, :left

   def initialize(value = nil, left = nil, right = nil)
		@value = value
		@left = left 
   	@right = right
   end 
end

class Tree
	def self.build_tree(array)
		return nil if array.length == 0 
		return Node.new(*array) if array.length == 1 
		sorted_arr = array.sort 

		mid = array.length / 2
		node = Node.new(sorted_arr[mid], 
							 build_tree(sorted_arr[0..(mid - 1)]), 
							 build_tree(sorted_arr[(mid + 1)..-1])
							)
		node
	end 

	def initialize(array)
		@root = Tree.build_tree(array)
	end 

	def insert(value, node = @root)
		if value < node.value
			if node.left.nil?
				node.left = Node.new(value)
			else 
				insert(value, node.left)
			end 
		else
			if node.right.nil?
				node.right = Node.new(value)
			else 
				insert(value, node.right)
			end 
		end
	end 

	def delete(value)
		pre_node, side = finding_pre_node(value)

		if pre_node == 0
			return nil											 
		elsif pre_node.nil?
			@root = Tree.build_tree(preorder_tree_values[1..-1])
		else
			if side == "left"
				all_values = preorder_tree_values(pre_node.left)
				pre_node.left = Tree.build_tree(all_values[1..-1])
			else 
				all_values = preorder_tree_values(pre_node.right)
				pre_node.right = Tree.build_tree(all_values[1..-1])
			end 
		end
	end 

	def finding_node(value, node = @root)
		return @root if @root.value == value
		return nil   if (value > node.value && node.right.nil?) || (value < node.value && node.left.nil?)

		if node.value == value
			return node
		elsif value > node.value
			finding_node(value, node.right)
		else
			finding_node(value, node.left)
		end 
	end 

	def finding_pre_node(value, node = @root) #returns an array with [root, side] if the methods finds the node, returns [0] if it doesn't exit and [nil, nil] if the "tree root" is the node. 
		return [nil, nil] if @root.value == value
		return [0]	if (value > node.value && node.right.nil?) || (value < node.value && node.left.nil?)

		if node.left.value == value
			[node, "left"]
		elsif node.right.value == value
			[node, "right"]
		elsif value > node.value
			finding_pre_node(value, node.right)
		else
			finding_pre_node(value, node.left)
		end 
	end

	def preorder_tree_values(root = @root, all_values = [])
		all_values << root.value
		inorder_tree_values(root.left, all_values) unless root.left.nil?
		inorder_tree_values(root.right, all_values) unless root.right.nil? 

		all_values
	end

	def inorder_tree_values(root = @root, all_values = [])
		inorder_tree_values(root.left, all_values) unless root.left.nil?
		all_values << root.value
		inorder_tree_values(root.right, all_values) unless root.right.nil? 

		all_values
	end	

	def postorder_tree_values(root = @root, all_values = [])
		inorder_tree_values(root.left, all_values) unless root.left.nil?
		inorder_tree_values(root.right, all_values) unless root.right.nil? 
		all_values << root.value

		all_values
	end 

	def level_order_it(queue = [], all_values = [])
		queue << @root
		until queue.empty?
			all_values << queue[0].value 
			queue << queue[0].left unless queue[0].left.nil? 
			queue << queue[0].right unless queue[0].right.nil? 

			queue.shift
		end
		
		all_values
	end

	def level_order_rec(queue = [@root], all_values = [])
		return all_values if queue.empty?

		all_values << queue[0].value
		queue << queue[0].left unless queue[0].left.nil?
		queue << queue[0].right unless queue[0].right.nil?
		queue.shift

		level_order_rec(queue, all_values)
	end 

	def height(node, height = 0) 
		return height if node.nil?
		return height if (node.left.nil? && node.right.nil?)

		if node.left.nil? && !node.left.nil?
			height(node.right, height + 1)
		elsif node.right.nil? && !node.left.nil?
			height(node.left, height + 1)
		elsif height(node.right, height + 1) > height(node.left, height + 1)
			height(node.right, height + 1)
		else
			height(node.left, height + 1)
		end 
	end

	def depth(node, current_node = @root, depth = 0) #node is the node we are trying to find the depth of while current_node is the node we are searching through
		return depth if node == current_node
		return nil if current_node.left.nil? && current_node.right.nil?

		p current_node
		p "---------------------------"

		if node.value > current_node.value
			depth(node, current_node.right, depth + 1)
		else
			depth(node, current_node.left, depth + 1)
		end
	end

	def balanced?(root = @root)
		return true if root.nil? 

		balanced?(root.left) && balanced?(root.right) && (2 > (height(root.left) - height(root.right)).abs)
	end

	def rebalance
		all_values = self.inorder_tree_values
		@root = Tree.build_tree(all_values)
	end 

   def pretty_print(node = @root, prefix = '', is_left = true)
   	pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
      pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
	end
end 
