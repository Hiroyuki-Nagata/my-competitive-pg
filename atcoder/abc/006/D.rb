lines = <<'EOS'
7
1
2
3
4
5
6
7
EOS

#lines = $stdin.read
array = lines.split("\n")

def ceil_index(array, l, r, key)
  while r-l > 1
    m = l + (r-l)/2
    if array[m] >= key
      r = m
    else
      l = m
    end
  end
  r
end

def get_lis(arr)

  tail = Array.new(arr.length)
  len = 1
  tail[0] = arr.first

  for i in 1...arr.length
    #puts tail.to_s

    if arr[i] < tail[0]
      # new smallest value
      tail[0] = arr[i]
    elsif arr[i] > tail[len-1]
      # arr[i] extends largest subsequence
      tail[len] = arr[i]
      len = len + 1
    else
      # option(a): use binary search
      # but, ruby's Array#bsearch_index requires
      # all array's elements sorted
      #idx = tail[0..i].compact.bsearch_index do |x|
      #  x >= arr[i]
      #end

      # option(b): implement binary search yourself
      idx = ceil_index(tail, -1, len-1, arr[i])
      tail[idx] = arr[i]
    end
  end

  #puts tail.to_s
  len
end

N = array[0].to_i
a = array[1..N].map(&:to_i).to_a

puts N - get_lis(a)
