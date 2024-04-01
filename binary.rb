class Tree
    def initialize(array)
        sorted_array = array.sort.uniq
        @root = build_tree(sorted_array, 0, sorted_array.length-1)
    end

    def build_tree(array, start, end)
        return nil if start > end

        mid = (start+end) / 2 
        root_node = Node.new(array[mid])

        root_node.left = build_tree(array, start, mid-1)
        root_node.right = build_tree(array, mid+1, end)

        return root_node
    end

    def insert(value)
        return @root = Node.new(value) if @root.nil?
        current_node = @root
        while current_node
            if value <= current_node.value
                if current_node.left.nil?
                    current_node.left = Node.new(value) 
                    break
                else
                    current_node = current_node.left
                end
            else
                if current_node.right.nil?
                    current_node.right = Node.new(value) 
                    break
                else
                    current_node = current_node.right
                end
            end
        end
    end

    def insertRecursive(value, node=@root)
        return Node.new(value) if node.nil?
        
        if value <= node.value
            node.left = insert(value, node.left)
        else
            node.right = insert(value, node.right)
        end

        node
    end

    def delete(value, node=@root)
        return nil if node.nil?

        if value < node.value
            node.left = delete(value, node.left)
        elsif value > node.value
            node.right = delete(value, node.right)
        else

            if node.left.nil? && node.right.nil?
                return nil
            elsif node.left.nil?
                return node.right
            elsif node.right.nil?
                return node.left
            else
                inorder_succesor = find_min(node.right)
                node.value = inorder_succesor.value
                node.right = delete(inorder_succesor.value, node.right)
            end
        end
        return node
    end

    def find_min(node)
        current_node = node
        while current_node.left
            current_node = current_node.left
        end
        return current_node
    end

    def find(value, node=@root)
        return nil if node.nil?

        if value < node.value
            return find(value, node.left)
        elsif value > node.value
            return find(value, node.right)
        else
            return node
        end
    end

    def level_order
        return [] if @root.nil?
        queue = [@root]
        results = []
    
        until queue.empty?
            level_size = queue.size
            current_level_values = []
    
            level_size.times do
                node = queue.shift
    
                if block_given?
                    yield(node)  
                else
                    current_level_values << node.value  
                end
    
                queue << node.left if node.left
                queue << node.right if node.right
            end
    
            results << current_level_values unless block_given?
        end
    
        results unless block_given?
    end

    def preorder(node = @root, values = [])
        return values if node.nil?
    
        if block_given?
            yield(node)  
        else
            values << node.value
        end
    
        preorder(node.left, values, &Proc.new) if node.left && block_given?
        preorder(node.right, values, &Proc.new) if node.right && block_given?
    
        preorder(node.left, values) if node.left && !block_given?
        preorder(node.right, values) if node.right && !block_given?
    
        values 
    end
    

    def inorder(node = @root, values = [], &block)
        return values if node.nil?
    
        inorder(node.left, values, &block)
    
        if block_given?
            yield(node)
        else
            values << node.value
        end
    
        inorder(node.right, values, &block)
    
        values
    end

    def postorder(node = @root, values = [], &block)
        return values if node.nil?
        
        postorder(node.right, values, &block)

        postorder(node.left, values, &block)
    
        if block_given?
            yield(node)
        else
            values << node.value
        end
    
        values
    end

    def height(node = @root)
        return -1 if node.nil?
    
        left_height = height(node.left)
        right_height = height(node.right)
    
        [left_height, right_height].max + 1
    end
    
    def depth(target, node=@root, current_depth=0)
        return -1 if node.nil?  
        return current_depth if node == target

        left_depth = node.left ? depth(target, node.left, current_depth+1) : -1
        right_depth = node.right ? depth(target, node.right, current_depth+1) : -1

        if left_depth == -1 && right_depth == -1
            return -1
        else
            return left_depth != -1 ? left_depth : right_depth
        end
    end

    def balanced?(node = @root)
        return true if node.nil?

        left_height = node.left ? height(node.left) : -1
        right_height = node.right ? height(node.right) : -1

        height_diff = (left_height - right_height).abs
        
        if height_diff <= 1 && balanced?(node.left) && balanced?(node.right)
            return true
        else
            return false
        end
    end

    def rebalance
        values = inorder  # Collects values in sorted order
        @root = build_tree(values, 0, values.length - 1)  # Rebuilds the tree
    end
    
end



class Node
    include Comparable

    attr_accessor :value, :left, :right

    def initialize(value=nil, left=nil, right=nil)
        @value = value
        @left = left
        @right = right
    end

    def <=>(other_node)
        return nil unless other_node.is_a?(Node) && other_node.value
        @value <=> other_node.value
    end
end

