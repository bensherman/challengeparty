#!/usr/bin env ruby

# https://www.rosettacode.org/wiki/Fibonacci_sequence#Recursive_with_Memoization_4
fib = Hash.new do |f, n|
  f[n] = if n <= -2
           (-1)**(n + 1) * f[n.abs]
         elsif n <= 1
           n.abs
         else
           f[n - 1] + f[n - 2]
         end
end

def triangle_output(s)
  triangled = []
  s.each_with_index do |row, i|
    triangled << " " * (s.size - i - 1)
    row.each_char do |c|
      triangled[i] << c + " "
    end
    triangled[i] << "\n"
  end
  triangled
end

def s_to_tri(s)
  # turns string of 55 chars into a triangle of 10 rows
  s.size != 55 ? raise("string must be 55 chars long") : nil
  tri = []
  10.times do |i|
    tri.push ""
    tri[i] << s[0..i]
    s = s[i+1..-1]
  end
  tri
end

puzzle = %w[
T
XF
PWD
NVQM
BPOQF
AENRVQ
LJSQTUW
FJHLCWMB
HZUMXYEQN
XBMGQTLKTF
]

ciphertext = puzzle.join
plaintext=""

ciphertext.size.times do |i|
  a = ciphertext[i].ord - "A".ord
  b = fib[i]
  c = (a - b) % 26
  d = (c + "A".ord).chr
  puts "#{d}\t#{a}\t#{c}\t\t#{b}"
  plaintext << d
end
puts triangle_output(s_to_tri(plaintext))
puts plaintext

# gets us to
# "TWENTYFIVEYEARSOFCHALLENGEVISITWZEROZEROWZEROZERODOTNET"
# https://w00w00.net
