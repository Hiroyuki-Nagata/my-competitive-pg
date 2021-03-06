MOD = 1_000_000_007

class Combination
  def initialize(n)
    @fact = (1..n).to_a
    @fact.each_with_index do |e, idx|
      @fact[idx] = @fact[idx] * @fact[idx-1] % MOD if idx > 0
    end
  end

  def choose(n, r)
    return 0 if not (0 <= r and r <= n)
    return 1 if r == 0 or r == n
    fact(n) * inverse( fact(r) * fact(n-r) % MOD ) % MOD
  end

  def fact(n)
    @fact[n-1]
  end

  def inverse(x)
    pow(x, MOD-2)
  end

  def pow(x, n)
    ans = 1
    while n > 0
      ans = ans * x % MOD if n.odd?
      x = x * x % MOD
      n >>= 1
    end
    ans
  end
end

lines = <<'EOS'
2 10000000
10000000 10000000
EOS

#lines = $stdin.read
array = lines.split("\n")
N,D = array[0].split(" ").map(&:to_i)
X,Y = array[1].split(" ").map(&:to_i)

comb = Combination.new(D)

ans  = 0
shortest = comb.choose(N, X/D)

if (X%D) != 0 or (Y%D) != 0
  puts 0.0
else
  for k in 0..N
    lr_move_k = k*D
    ud_move_k = (N-k)*D

    next if lr_move_k < X or ud_move_k < Y

    lr_r = (lr_move_k+X)/2
    ud_r = (ud_move_k+Y)/2

    lr = comb.choose(lr_move_k, lr_r)
    ud = comb.choose(ud_move_k, ud_r)

    tmp = (shortest*lr*ud)
    ans += tmp
    puts "#{shortest} * #{lr_move_k}C#{lr_r}=#{lr} * #{ud_move_k}C#{ud_r}=#{ud} = #{tmp}"
  end
  puts ans.quo(4**N).to_f
end
