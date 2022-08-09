#!/usr/bin env ruby

require "byebug"
require "vigenere"
require "pp"

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

def unroll_right(s)
  s.size != 55 ? raise("string must be 55 chars long") : nil
  tri = s_to_tri(s)
  tri.reverse!
  new_tri = ""
  circle = 0
  while tri.size > 0
    new_tri << tri.shift
    tri.each_with_index do |row, i|
      new_tri += row[-1]
      tri[i] = row[0..-2]
    end
    tri.pop
    tri.reverse!
    tri.each_with_index do |row, i|
      new_tri += row[0]
      tri[i] = row[1..]
    end
    popped_row = tri.shift
    tri.reverse!
    circle += 1
  end
  new_tri
end

def unroll_left(s)
  mirror = s_to_tri(s).map { |row| row.reverse }
  unroll_right(mirror.join)
end

def rotate_tri(ten_array)
  rotated = []
  10.times do
    rotated << ""
  end

  10.times do |i|
    ten_array.each do |row|
      row[i] ? rotated[i] << row[i] : rotated[i] << ""
    end
  end
  rotated.reverse
end


QBERT = [
"T",
"XF",
"PWD",
"NVQM",
"BPOQF",
"AENRVQ",
"LJSQTUW",
"FJHLCWMB",
"HZUMXYEQN",
"XBMGQTLKTF"
]


qbert_ccw = rotate_tri(QBERT)
qbert_cw = rotate_tri(qbert_ccw)

def get_perms(s)
  s_ccw = rotate_tri(s)
  s_cw = rotate_tri(s_ccw)
  {
  main: s.join,
  ccw: s_ccw.join,
  cw: s_cw.join,
  unrolled_right_ccw: unroll_right(s_ccw.join),
  unrolled_right_cw:unroll_right(s_cw.join),
  unrolled_right: unroll_right(s.join),
  unrolled_left_ccw: unroll_left(s_ccw.join),
  unrolled_left_cw: unroll_left(s_cw.join),
  unrolled_left: unroll_left(s.join)
}
end

def print_perms(s)
  perms = get_perms(s)
  put perms.each_pair.map { |k, v| "#{v} # #{k}" }.join("\n")
end

puts triangle_output(QBERT)
# puts
# perms = get_perms(QBERT)
# puts perms.each_pair.map { |k, v| "#{v} # #{k}" }.join("\n")

# OEIS - https://oeis.org/A007318
pascals_triangle =
[
1,
1, 1,
1, 2, 1,
1, 3, 3, 1,
1, 4, 6, 4, 1,
1, 5, 10, 10, 5, 1,
1, 6, 15, 20, 15, 6, 1,
1, 7, 21, 35, 35, 21, 7, 1,
1, 8, 28, 56, 70, 56, 28, 8, 1,
1, 9, 36, 84, 126, 126, 84, 36, 9, 1,
1, 10, 45, 120, 210, 252, 210, 120, 45, 10, 1
]

qbert = QBERT.join
plaintext=""

qbert.size.times do |i|
  a = qbert[i].ord
  b = pascals_triangle[i]
  c = a + b
  begin
    d = c.chr
  rescue
    d = "."
  end
  puts "#{a}\t#{b.chr}\t#{c}\t#{d}"
  plaintext << d
end
puts triangle_output(s_to_tri(plaintext))
return

# puts QBERT
# puts qbert_ccw
# puts qbert_cw

def show_me(ciphertexts, keys)
  ciphertexts.each do |ciphertext|
    keys.each do |key|
      plaintext = Vigenere.decode(key, ciphertext)
      puts "Key: #{key}, Ciphertext: #{ciphertext}"
      puts "Plaintext: #{plaintext}"
      puts "as triangle:\n#{triangle_output(s_to_tri(plaintext)).join}\n"
    end
  end
end

ciphertexts = [QBERT.join, qbert_ccw.join, qbert_cw.join]
keys = %w[
QBERT
HTTP
BITLY
TINYURL
CAEZAR
CHALLENGE
CHALLENGEPARTY
HEXAGON
TRIANGLE
DEFCON
]

show_me(ciphertexts, keys)
return

# QBERT is an array, input from puzzle.jpg
# in qbert, one can only go down left or down right.
# I assume this is the case in this puzzle, and we will get 10 letters of ciphertext.

# qbert's caption is !%##
# that gives a hint that we may need the ordinal vaules of the letters.
# the ! at the begininng may indicate that we specifically don't.

# in the array, if you go to the next element, the choice of which char is next in the string is
# the position you are in in the current row.
# if we start with QBERT[0], which is T,
# the next line is either QBERT[1][0] or QBERT[1][1]. X or F

# we have 9 choices to make.
# 2 ** 9 = 512

# let's generate every string:

def qbert_jump(pyramid, s)
  s << pyramid.shift
  if pyramid.size > 0
    left = pyramid.map { |row| row[..-2] }
    right = pyramid.map { |row| row[1..] }
    qbert_jump(left, s.clone)
    qbert_jump(right, s.clone)
  else
    puts s
  end
end
# puts qbert_jump(QBERT.clone, "")

everything = %w[
TXPNBALFHX
TXPNBALFHB
TXPNBALFZB
TXPNBALFZM
TXPNBALJZB
TXPNBALJZM
TXPNBALJUM
TXPNBALJUG
TXPNBAJJZB
TXPNBAJJZM
TXPNBAJJUM
TXPNBAJJUG
TXPNBAJHUM
TXPNBAJHUG
TXPNBAJHMG
TXPNBAJHMQ
TXPNBEJJZB
TXPNBEJJZM
TXPNBEJJUM
TXPNBEJJUG
TXPNBEJHUM
TXPNBEJHUG
TXPNBEJHMG
TXPNBEJHMQ
TXPNBESHUM
TXPNBESHUG
TXPNBESHMG
TXPNBESHMQ
TXPNBESLMG
TXPNBESLMQ
TXPNBESLXQ
TXPNBESLXT
TXPNPEJJZB
TXPNPEJJZM
TXPNPEJJUM
TXPNPEJJUG
TXPNPEJHUM
TXPNPEJHUG
TXPNPEJHMG
TXPNPEJHMQ
TXPNPESHUM
TXPNPESHUG
TXPNPESHMG
TXPNPESHMQ
TXPNPESLMG
TXPNPESLMQ
TXPNPESLXQ
TXPNPESLXT
TXPNPNSHUM
TXPNPNSHUG
TXPNPNSHMG
TXPNPNSHMQ
TXPNPNSLMG
TXPNPNSLMQ
TXPNPNSLXQ
TXPNPNSLXT
TXPNPNQLMG
TXPNPNQLMQ
TXPNPNQLXQ
TXPNPNQLXT
TXPNPNQCXQ
TXPNPNQCXT
TXPNPNQCYT
TXPNPNQCYL
TXPVPEJJZB
TXPVPEJJZM
TXPVPEJJUM
TXPVPEJJUG
TXPVPEJHUM
TXPVPEJHUG
TXPVPEJHMG
TXPVPEJHMQ
TXPVPESHUM
TXPVPESHUG
TXPVPESHMG
TXPVPESHMQ
TXPVPESLMG
TXPVPESLMQ
TXPVPESLXQ
TXPVPESLXT
TXPVPNSHUM
TXPVPNSHUG
TXPVPNSHMG
TXPVPNSHMQ
TXPVPNSLMG
TXPVPNSLMQ
TXPVPNSLXQ
TXPVPNSLXT
TXPVPNQLMG
TXPVPNQLMQ
TXPVPNQLXQ
TXPVPNQLXT
TXPVPNQCXQ
TXPVPNQCXT
TXPVPNQCYT
TXPVPNQCYL
TXPVONSHUM
TXPVONSHUG
TXPVONSHMG
TXPVONSHMQ
TXPVONSLMG
TXPVONSLMQ
TXPVONSLXQ
TXPVONSLXT
TXPVONQLMG
TXPVONQLMQ
TXPVONQLXQ
TXPVONQLXT
TXPVONQCXQ
TXPVONQCXT
TXPVONQCYT
TXPVONQCYL
TXPVORQLMG
TXPVORQLMQ
TXPVORQLXQ
TXPVORQLXT
TXPVORQCXQ
TXPVORQCXT
TXPVORQCYT
TXPVORQCYL
TXPVORTCXQ
TXPVORTCXT
TXPVORTCYT
TXPVORTCYL
TXPVORTWYT
TXPVORTWYL
TXPVORTWEL
TXPVORTWEK
TXWVPEJJZB
TXWVPEJJZM
TXWVPEJJUM
TXWVPEJJUG
TXWVPEJHUM
TXWVPEJHUG
TXWVPEJHMG
TXWVPEJHMQ
TXWVPESHUM
TXWVPESHUG
TXWVPESHMG
TXWVPESHMQ
TXWVPESLMG
TXWVPESLMQ
TXWVPESLXQ
TXWVPESLXT
TXWVPNSHUM
TXWVPNSHUG
TXWVPNSHMG
TXWVPNSHMQ
TXWVPNSLMG
TXWVPNSLMQ
TXWVPNSLXQ
TXWVPNSLXT
TXWVPNQLMG
TXWVPNQLMQ
TXWVPNQLXQ
TXWVPNQLXT
TXWVPNQCXQ
TXWVPNQCXT
TXWVPNQCYT
TXWVPNQCYL
TXWVONSHUM
TXWVONSHUG
TXWVONSHMG
TXWVONSHMQ
TXWVONSLMG
TXWVONSLMQ
TXWVONSLXQ
TXWVONSLXT
TXWVONQLMG
TXWVONQLMQ
TXWVONQLXQ
TXWVONQLXT
TXWVONQCXQ
TXWVONQCXT
TXWVONQCYT
TXWVONQCYL
TXWVORQLMG
TXWVORQLMQ
TXWVORQLXQ
TXWVORQLXT
TXWVORQCXQ
TXWVORQCXT
TXWVORQCYT
TXWVORQCYL
TXWVORTCXQ
TXWVORTCXT
TXWVORTCYT
TXWVORTCYL
TXWVORTWYT
TXWVORTWYL
TXWVORTWEL
TXWVORTWEK
TXWQONSHUM
TXWQONSHUG
TXWQONSHMG
TXWQONSHMQ
TXWQONSLMG
TXWQONSLMQ
TXWQONSLXQ
TXWQONSLXT
TXWQONQLMG
TXWQONQLMQ
TXWQONQLXQ
TXWQONQLXT
TXWQONQCXQ
TXWQONQCXT
TXWQONQCYT
TXWQONQCYL
TXWQORQLMG
TXWQORQLMQ
TXWQORQLXQ
TXWQORQLXT
TXWQORQCXQ
TXWQORQCXT
TXWQORQCYT
TXWQORQCYL
TXWQORTCXQ
TXWQORTCXT
TXWQORTCYT
TXWQORTCYL
TXWQORTWYT
TXWQORTWYL
TXWQORTWEL
TXWQORTWEK
TXWQQRQLMG
TXWQQRQLMQ
TXWQQRQLXQ
TXWQQRQLXT
TXWQQRQCXQ
TXWQQRQCXT
TXWQQRQCYT
TXWQQRQCYL
TXWQQRTCXQ
TXWQQRTCXT
TXWQQRTCYT
TXWQQRTCYL
TXWQQRTWYT
TXWQQRTWYL
TXWQQRTWEL
TXWQQRTWEK
TXWQQVTCXQ
TXWQQVTCXT
TXWQQVTCYT
TXWQQVTCYL
TXWQQVTWYT
TXWQQVTWYL
TXWQQVTWEL
TXWQQVTWEK
TXWQQVUWYT
TXWQQVUWYL
TXWQQVUWEL
TXWQQVUWEK
TXWQQVUMEL
TXWQQVUMEK
TXWQQVUMQK
TXWQQVUMQT
TFWVPEJJZB
TFWVPEJJZM
TFWVPEJJUM
TFWVPEJJUG
TFWVPEJHUM
TFWVPEJHUG
TFWVPEJHMG
TFWVPEJHMQ
TFWVPESHUM
TFWVPESHUG
TFWVPESHMG
TFWVPESHMQ
TFWVPESLMG
TFWVPESLMQ
TFWVPESLXQ
TFWVPESLXT
TFWVPNSHUM
TFWVPNSHUG
TFWVPNSHMG
TFWVPNSHMQ
TFWVPNSLMG
TFWVPNSLMQ
TFWVPNSLXQ
TFWVPNSLXT
TFWVPNQLMG
TFWVPNQLMQ
TFWVPNQLXQ
TFWVPNQLXT
TFWVPNQCXQ
TFWVPNQCXT
TFWVPNQCYT
TFWVPNQCYL
TFWVONSHUM
TFWVONSHUG
TFWVONSHMG
TFWVONSHMQ
TFWVONSLMG
TFWVONSLMQ
TFWVONSLXQ
TFWVONSLXT
TFWVONQLMG
TFWVONQLMQ
TFWVONQLXQ
TFWVONQLXT
TFWVONQCXQ
TFWVONQCXT
TFWVONQCYT
TFWVONQCYL
TFWVORQLMG
TFWVORQLMQ
TFWVORQLXQ
TFWVORQLXT
TFWVORQCXQ
TFWVORQCXT
TFWVORQCYT
TFWVORQCYL
TFWVORTCXQ
TFWVORTCXT
TFWVORTCYT
TFWVORTCYL
TFWVORTWYT
TFWVORTWYL
TFWVORTWEL
TFWVORTWEK
TFWQONSHUM
TFWQONSHUG
TFWQONSHMG
TFWQONSHMQ
TFWQONSLMG
TFWQONSLMQ
TFWQONSLXQ
TFWQONSLXT
TFWQONQLMG
TFWQONQLMQ
TFWQONQLXQ
TFWQONQLXT
TFWQONQCXQ
TFWQONQCXT
TFWQONQCYT
TFWQONQCYL
TFWQORQLMG
TFWQORQLMQ
TFWQORQLXQ
TFWQORQLXT
TFWQORQCXQ
TFWQORQCXT
TFWQORQCYT
TFWQORQCYL
TFWQORTCXQ
TFWQORTCXT
TFWQORTCYT
TFWQORTCYL
TFWQORTWYT
TFWQORTWYL
TFWQORTWEL
TFWQORTWEK
TFWQQRQLMG
TFWQQRQLMQ
TFWQQRQLXQ
TFWQQRQLXT
TFWQQRQCXQ
TFWQQRQCXT
TFWQQRQCYT
TFWQQRQCYL
TFWQQRTCXQ
TFWQQRTCXT
TFWQQRTCYT
TFWQQRTCYL
TFWQQRTWYT
TFWQQRTWYL
TFWQQRTWEL
TFWQQRTWEK
TFWQQVTCXQ
TFWQQVTCXT
TFWQQVTCYT
TFWQQVTCYL
TFWQQVTWYT
TFWQQVTWYL
TFWQQVTWEL
TFWQQVTWEK
TFWQQVUWYT
TFWQQVUWYL
TFWQQVUWEL
TFWQQVUWEK
TFWQQVUMEL
TFWQQVUMEK
TFWQQVUMQK
TFWQQVUMQT
TFDQONSHUM
TFDQONSHUG
TFDQONSHMG
TFDQONSHMQ
TFDQONSLMG
TFDQONSLMQ
TFDQONSLXQ
TFDQONSLXT
TFDQONQLMG
TFDQONQLMQ
TFDQONQLXQ
TFDQONQLXT
TFDQONQCXQ
TFDQONQCXT
TFDQONQCYT
TFDQONQCYL
TFDQORQLMG
TFDQORQLMQ
TFDQORQLXQ
TFDQORQLXT
TFDQORQCXQ
TFDQORQCXT
TFDQORQCYT
TFDQORQCYL
TFDQORTCXQ
TFDQORTCXT
TFDQORTCYT
TFDQORTCYL
TFDQORTWYT
TFDQORTWYL
TFDQORTWEL
TFDQORTWEK
TFDQQRQLMG
TFDQQRQLMQ
TFDQQRQLXQ
TFDQQRQLXT
TFDQQRQCXQ
TFDQQRQCXT
TFDQQRQCYT
TFDQQRQCYL
TFDQQRTCXQ
TFDQQRTCXT
TFDQQRTCYT
TFDQQRTCYL
TFDQQRTWYT
TFDQQRTWYL
TFDQQRTWEL
TFDQQRTWEK
TFDQQVTCXQ
TFDQQVTCXT
TFDQQVTCYT
TFDQQVTCYL
TFDQQVTWYT
TFDQQVTWYL
TFDQQVTWEL
TFDQQVTWEK
TFDQQVUWYT
TFDQQVUWYL
TFDQQVUWEL
TFDQQVUWEK
TFDQQVUMEL
TFDQQVUMEK
TFDQQVUMQK
TFDQQVUMQT
TFDMQRQLMG
TFDMQRQLMQ
TFDMQRQLXQ
TFDMQRQLXT
TFDMQRQCXQ
TFDMQRQCXT
TFDMQRQCYT
TFDMQRQCYL
TFDMQRTCXQ
TFDMQRTCXT
TFDMQRTCYT
TFDMQRTCYL
TFDMQRTWYT
TFDMQRTWYL
TFDMQRTWEL
TFDMQRTWEK
TFDMQVTCXQ
TFDMQVTCXT
TFDMQVTCYT
TFDMQVTCYL
TFDMQVTWYT
TFDMQVTWYL
TFDMQVTWEL
TFDMQVTWEK
TFDMQVUWYT
TFDMQVUWYL
TFDMQVUWEL
TFDMQVUWEK
TFDMQVUMEL
TFDMQVUMEK
TFDMQVUMQK
TFDMQVUMQT
TFDMFVTCXQ
TFDMFVTCXT
TFDMFVTCYT
TFDMFVTCYL
TFDMFVTWYT
TFDMFVTWYL
TFDMFVTWEL
TFDMFVTWEK
TFDMFVUWYT
TFDMFVUWYL
TFDMFVUWEL
TFDMFVUWEK
TFDMFVUMEL
TFDMFVUMEK
TFDMFVUMQK
TFDMFVUMQT
TFDMFQUWYT
TFDMFQUWYL
TFDMFQUWEL
TFDMFQUWEK
TFDMFQUMEL
TFDMFQUMEK
TFDMFQUMQK
TFDMFQUMQT
TFDMFQWMEL
TFDMFQWMEK
TFDMFQWMQK
TFDMFQWMQT
TFDMFQWBQK
TFDMFQWBQT
TFDMFQWBNT
TFDMFQWBNF]

# QBERT.each do |word|
#   word.each_char do |char|
#     printf("%d ", char.ord)
#   end
#   puts
# end

# 84
# 88 70
# 80 87 68
# 78 86 81 77
# 66 80 79 81 70
# 65 69 78 82 86 81
# 76 74 83 81 84 85 87
# 70 74 72 76 67 87 77 66
# 72 90 85 77 88 89 69 81 78
# 88 66 77 71 81 84 76 75 84 70


# everything.each do |word|
#   word.each_char do |char|
#     printf("%d ", char.ord)
#   end
#   puts
# end

# def rot_x(x, string)
#   # quick and dirty, assume all caps A-Z
#   # "A".ord == 65
#   new_string = ""
#   string.each_char do |char|
#     new_string << (char.ord - 65 + x).modulo(26).+(65).chr
#   end
#   new_string
# end

# # 26.times do |x|
# #   puts x
# #   QBERT.each do |word|
# #     puts rot_x(x, word)
# #   end
# # end



# # do I spot "QED fuck fb"
# rot_11 = %w[
# I
# MU
# ELS
# CKFB
# QEDFU
# PTCGKF
# AYHFIJL
# UYWARLBQ
# WOJBMNTFC
# MQBVFIAZIU
# ]

# # puts rot_11.reverse.join
# # => MQBVFIAZIUWOJBMNTFCUYWALRBQAYHFIJLPTCGKFQEDFUCKFBELSMUI
# joined = QBERT.join
# puts joined
# puts joined.split(//).uniq.count
# => 25
# puts joined.split(//).uniq.sort.join
# => ABCDEFGHJKLMNOPQRSTUVWXYZ
# only "I" is missing

# rot_11 turns the top of the pyramid to I
# probably not coincidence!

# in previous contests, weird bases were used, like base 6.
# ruby makes this pretty easy to convert

# QBERT.each do |word|
#   word.each_char do |char|
#     puts "base 10: #{char.ord}"
#     puts "base 6: #{char.ord.to_s(2)}"
#   end
# end

# thinking about later levels in the original game, qbert could go up or down. and hit the same squres multiple times.
# what if rotate the puzzle and have qbert be on top

# QBERT_60_CCW = %w[
#   F
#   NT
#   BQK
#   WMEL
#   QUWYT
#   FVTCXQ
#   MQRQLMG
#   DQONSHUM
#   FWVPEJJZB
#   TXPNBALFHX
# ]
# eyeball that the inputs match
# puts QBERT.join.split(//).sort.join == QBERT_60_CCW.join.split(//).sort.join
# puts QBERT_60_CCW
# qbert_jump(QBERT_60_CCW.clone, "")
# puts QBERT.map {|s| s.tr " ", ""}.join

def rot_tr(s, i=1)
  i.times do
    s = s[1..] + s[0]
  end
  s
end

CAPS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
# (0..CAPS.size).each do |i|
#   puts QBERT.map{ |s| s.tr CAPS, rot_tr(CAPS, i)}
#   puts
# end

puts "original: \n#{QBERT.join("\n")}"
no_spaces = QBERT.map {|s| s.tr " ", ""}.join
puts "no spaces: #{no_spaces}"
first_chars = QBERT.map {|s| s.gsub(/\s+/, "")[0] }.join
puts "first_chars: #{first_chars}"
last_chars = QBERT.map {|s| s.gsub(/\s+/, "")[-1] }.join
puts "last_chars: #{last_chars}"
last_line = QBERT.last.gsub(/\s+/, "")
puts "last_line: #{last_line}"

inputs = [

]

# It’s just a cipher with a well known key stream implied by the shape
# 😊 well maybe not quite that “well known” but the shape is the key

keys = File.readlines("wordlist", chomp: true).to_set
out = File.open("output3", "w")
keys.each do |key|
  inputs.each do |input|
    out.write "input: #{input}     key: #{key}    output: #{Vigenere.decode(key, input)}\n"
  end
end
# output = File.readlines("output", chomp: true)
# i = 0
# keys.each do |key|
#   key.size < 6 ? next : nil
#   output.each do |line|
#     line.include?(key) ? puts("line: #{line}                    key: #{key}") : nil
#   end
#   i += 1
#   i % 100 == 0 ? (puts("#{i}: #{key}"); $stdout.flush) : nil
# end

# [.../code/challengeparty/2022] (2022|*|U)% grep key: matches
# line: SBLIMPSJJM                    key: BLIMPS
# line: UBOVINERQF                    key: BOVINE
# line: UBOVINERBC                    key: BOVINE
# line: QDACTYLEZM                    key: DACTYL
# line: QDACTYLMDU                    key: DACTYL
# line: QDACTYLMDU                    key: DACTYL
# line: QDACTYLMDF                    key: DACTYL
# line: QDACTYLMZK                    key: DACTYL
# line: QDACTYLMZJ                    key: DACTYL
# line: QDACTYLMZJ                    key: DACTYL
# line: QDACTYLMTG                    key: DACTYL
# line: QDACTYLMTG                    key: DACTYL
# line: INVEIGHVFO                    key: INVEIGH
# line: LENGTHJYZE                    key: LENGTH
# line: RYDTMILDLY                    key: MILDLY
# line: BQPARITYHK                    key: PARITY
# line: PORCINECGK                    key: PORCINE
# line: PORCINECGZ                    key: PORCINE
# line: STINGSYZGT                    key: STINGS
# line: STINGSXLQW                    key: STINGS
# line: STINGSXLQX                    key: STINGS
# line: STINGSXLQX                    key: STINGS
# line: STINGSXLQP                    key: STINGS
# line: STINGSXLQP                    key: STINGS
# line: STINGSXLQP                    key: STINGS
# line: STINGSXLQF                    key: STINGS
# line: VBZTWILITS                    key: TWILIT
# line: SNBVIRAGOR                    key: VIRAGO

inputs = [
no_spaces,
first_chars,
first_chars.reverse,
last_chars,
last_chars.reverse,
last_line,
last_line.reverse,
]

puts "testing my ideas of keys"
my_keys = %w[
QBERT
HTTP
BITLY
TINYURL
CAEZAR
CHALLENGE
CHALLENGEPARTY
]
my_keys.each do |key|

  inputs.each do |input|
    out = Vigenere.decode(key, input)
    puts "input: #{input}, key: #{key}, output: #{out}"
  end
end