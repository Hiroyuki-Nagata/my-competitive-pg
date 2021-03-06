INF  = 999999999

class Node
  property :u, :d, :c, :p
  @u : Int32
  @d : Int32
  @c : Symbol
  @p : Int32
  def initialize()
    @u = 0
    @d = 0
    @c = :white
    @p = 0
  end
end

class Graph
  property :nodes, :mat, :u_start

  @nodes : Array(Node)
  @mat   : Array(Array(Int32))

  def initialize(n, matrix, u_start_with = 1)
    @nodes = Array(Node).new(n)
    @nodes.each_with_index{|node,idx| node.u = idx+u_start_with}
    @u_start = u_start_with
    @mat   = matrix.dup
  end

  def edge_exists?(row, col)
    #printf "  edge_exists?(#{row}, #{col}) => "
    row -= @u_start
    col -= @u_start
    result = if @mat[row][col] != -1 # or @mat[col][row] != -1
               true
             else
               false
             end
    #puts "#{result} => cost: #{@mat[row][col]}"
    result
  end

  def gen_uniq_edges()
    edges = [] of Int32
    @nodes.each_with_index do |node,i|
      mat[i].map.with_index.select do |w,idx|
        w != -1
      end.each do |w,idx|
        edge = [node.u, idx+@u_start]
        edges << edge
      end
    end
    edges.uniq
  end

  def dot_before_dijkstra()
    puts "graph beforeDijkstra {"
    gen_uniq_edges.each do |e|
      puts "  \"#{e.first}\" -- \"#{e.last}\" [label=#{mat[e.first-@u_start][e.last-@u_start]}]"
    end
    puts "}"
  end

  def dot_after_dijkstra(start = 1)
    # start dijkstra
    dijkstra(start)

    # then, generate dot
    puts "digraph afterDijkstra {"
    gen_uniq_edges.each do |e|
      no = mat[e.first-1.to_i].detect {|m| m != -1 && (m == e.last-1 || m == e.first-1) }
      if no.nil?
        puts "  \"#{e.first}\" -- \"#{e.last}\" [label=\"w=#{mat[e.first-1][e.last-1]}\"]"
      else
        puts "  \"#{e.first}\" -- \"#{e.last}\" [label=\"w=#{mat[e.first-1][e.last-1]} (#{no})\", penwidth=3]"
      end
    end
    puts "}"
  end

  def dijkstra(start = 1)

    puts @nodes.to_s

    # @nodes = @nodes.each do |node|
    #   node.d = INF
    #   node.p = -1
    #   node.c = :white
    # end
    #
    # start = (start-@u_start).to_i
    # @nodes[start].d = 0
    # @nodes[start].p = -1
    # next_u = nil
    #
    # while true
    #   mincost = INF
    #   @nodes.each do |node|
    #     if node.c != :black && node.d < mincost
    #       #puts "node.d = #{node.d}"
    #       mincost = node.d
    #       next_u  = node.u
    #     end
    #   end
    #   #puts "mincost = #{mincost}, next_u = #{next_u}"
    #
    #   break if mincost == INF
    #
    #   @nodes[next_u].c = :black
    #
    #   @nodes = @nodes.map.with_index do |node, v|
    #     if node.c != :black && edge_exists?(next_u, v) && @nodes[next_u].d + mat[next_u][v] < node.d
    #       node.d = @nodes[next_u].d + mat[next_u][v]
    #       node.p = next_u
    #       node.c = :gray
    #       node
    #     else
    #       node
    #     end
    #   end
    # end
  end
end

lines = <<-'EOS'
5 5
1 2 12
2 3 14
3 4 7
4 5 9
5 1 18
EOS

#lines = $stdin.read

array = lines.split("\n")

n = array[0].split(" ")[0].to_i
m = array[0].split(" ")[1].to_i

mat = Array.new(n, Array.new(n, -1))

(1..m).each do |i|
  u,v,w = array[i].split(" ").map(&.to_i)
  mat[u-1][v-1] = w
  mat[v-1][u-1] = w
end

# 0-indexed
graph = Graph.new(n, mat, 0)

# start-with 0
# graph.dot_before_dijkstra()

min_t = graph.nodes.map do |n|
  graph = Graph.new(n, mat, 0)
  graph.dijkstra(n.u)
  graph.nodes.max_by{|node| node.d}.d
end.to_a.min
#
# puts min_t
