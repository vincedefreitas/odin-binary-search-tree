require_relative 'node.rb'

class Tree
  attr_accessor :arr, :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return if array.empty?
    sorted_array = array.sort.uniq
    mid = sorted_array.length / 2
    root = Node.new(sorted_array[mid])
    root.left = build_tree(sorted_array[0...mid])
    root.right = build_tree(sorted_array[(mid + 1)..-1])
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = @root)
    return @root = Node.new(value) if @root.nil?
    return @root if @root.data == value
    return Node.new(value) if node.nil?
    if value < node.data
      node.left = insert(value, node.left)
    else
      node.right = insert(value, node.right)
    end
    node
  end

  def delete(value, node = @root)
    return @root if @root.nil?
    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      if node.left.nil?
        temp = node.right
        node = nil
        return temp
      elsif node.right.nil?
        temp = node.left
        node = nil
        return temp
      end
      temp = next_min_value(node.right)
      node.data = temp.data
      node.right = delete(temp.data, node.right)
    end
    node
  end

  def next_min_value(node)
    current = node
    current = current.left until current.left.nil?
    current
  end

  def find(value, node = @root)
    return nil if node.nil?
    return node if node.data == value
    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def level_order(node = @root, queue = [])
    print "#{node.data}"
    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?
    return if queue.empty?

    level_order(queue.shift, queue)
  end

  def preorder(node = @root)
    return if node.nil?
    print "#{node.data}"
    preorder(node.left)
    preorder(node.right)
  end

  def inorder(node = @root, output = [])
    return if node.nil?
    inorder(node.left, output)
    output << node.data
    inorder(node.right, output)
    output
  end

  def postorder(node = @root)
    return if node.nil?
    postorder(node.left)
    postorder(node.right)
    print "#{node.data}"
  end

  def height(node = @root, count = -1)
    return count if node.nil?
    count += 1
    [height(node.left, count), height(node.right, count)].max
  end

  def depth(value)
    current = @root
    count = 0
    return nil if current.nil?
    until current.data == value
      count += 1
      current = current.left if value < current.data
      current = current.right if value > current.data
    end
    count
  end

  def balanced?
    left = height(@root.left, 0)
    right = height(@root.right, 0)
    (left - right).between?(-1, 1)
  end

  def rebalance
    arr = inorder
    @root = build_tree(arr)
  end
end

array = Array.new(15) { rand(1..100)}
tree = Tree.new(array)
p tree.balanced?
p tree.preorder
p tree.postorder
p tree.inorder
10.times do
  a = rand(100..150)
  tree.insert(a)
end
p tree.balanced?
tree.rebalance
p tree.balanced?