f = open("all-hand.txt")

text = {"c":"", "y":"", "p":"", "r":""}
linenum = 0

for line in f:
    linenum += 1
    line = line.strip().split(":")
    cypher = line[0].split(",")
    colors = line[1].split(",")
    if len(cypher) != len(colors):
        print "error on line {} ".format(linenum)
        print len(cypher), len(colors)
    for i in range(len(cypher)):
        text[colors[i]] += cypher[i]

y_bytes = []
c_bytes = []
p_bytes = []

for i in xrange(0,len(text["y"]),3):
    y_bytes += [int(text["y"][i:i+3])]
y = "".join(chr(b) for b in y_bytes)
for i in xrange(0,len(text["c"]),3):
    c_bytes += [int(text["c"][i:i+3])]
c = "".join(chr(b) for b in c_bytes)
for i in xrange(0,len(text["p"]),3):
    p_bytes += [int(text["p"][i:i+3])]
p = "".join(chr(b) for b in p_bytes)

import string
rot13 = string.maketrans(
    "ABCDEFGHIJKLMabcdefghijklmNOPQRSTUVWXYZnopqrstuvwxyz",
    "NOPQRSTUVWXYZnopqrstuvwxyzABCDEFGHIJKLMabcdefghijklm")
print "y: ", string.translate(y, rot13)
print "c: ", string.translate(c, rot13)

caezar = string.maketrans(
  "ABCDEFGHIJKMLNOPQRSTUVWXYZabcdefhijklmnopqrstuvwxyz",
  " N H     ASD MERTIGO   CP  n h  l asd mertigo bycp ")
print "p: ", p
print "p: ", string.translate(p, caezar)
print "r: ", text["r"]
