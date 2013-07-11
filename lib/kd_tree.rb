class KdTree
  Node = Struct.new(:id, :coords, :left, :right)
 
  def initialize(points)
    @root = build_tree(points)
    @nearest = []
  end
 
  def find_nearest(target, k_nearest)
    @nearest = []
    nearest(@root, target, k_nearest, 0)
  end
 
  def find_by_id(id)
    return find_by_id_recursive(@root, id)
  end
 
  private
 
  def build_tree(points, depth=0)
    return if points.empty?
 
    axis = depth % 2
 
    points.sort! { |a, b| a[1][axis] <=> b[1][axis] }
    median = points.size / 2
 
    node = Node.new(points[median][0], points[median][1], nil, nil)
    node.left = build_tree(points[0...median], depth + 1)
    node.right = build_tree(points[median+1..-1], depth + 1)
    node
  end
 
  def distance2(node, target)
    return nil if node.nil? || target.nil?
 
    x = (node.coords[0] - target[0])
    y = (node.coords[1] - target[1])
    x * x + y * y
  end
 
  def check_nearest(nearest, node, target, k_nearest)
    d = distance2(node, target)
    if nearest.size < k_nearest || d < nearest.last[0]
      nearest.pop if nearest.size >= k_nearest
      nearest << [d, node.id, node.coords]
      nearest.sort! { |a, b| a[0] <=> b[0] }
    end
    nearest
  end
 
  def nearest(node, target, k_nearest, depth)
    axis = depth % 2
 
    # leaf node
    if node.left.nil? && node.right.nil?
      @nearest = check_nearest(@nearest, node, target, k_nearest)
      return
    end
 
    # go down the nearest split
    if node.right.nil? || (node.left && target[axis] <= node.coords[axis])
      nearer = node.left
      further = node.right
    else
      nearer = node.right
      further = node.left
    end
    nearest(nearer, target, k_nearest, depth+1)
 
    # see if we have to check other side
    if further
      if @nearest.size < k_nearest || (target[axis] - node.coords[axis])**2 < @nearest.last[0]
        nearest(further, target, k_nearest, depth+1)
      end
    end
 
    @nearest = check_nearest(@nearest, node, target, k_nearest)
  end
 
  def find_by_id_recursive(node, id)
    if node.id == id
      coords = node.coords
    elsif node.nil?
      coords = nil
    else
      coords = find_by_id_recursive(node.left, id) || find_by_id_recursive(node.right, id)
    end
    coords
  end
end