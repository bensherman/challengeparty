"""
red orange yellow green blue purple

each line is 18 chars long

3 char chunks, in base 6 encoding.

the hard part was the data entry, though if I had more time, I would have used pil/pillow.

TIL: int() lets you specify a base when you are casting from a string.

"""

from pprint import pprint

badge = [b'yygybpgrrybggrggro',
         b'ybprpygoygrgrpygoy',
         b'ypyybprpyopoypyybo',
         b'grrgrrybpgryypoybp',
         b'rpyyoyybogorgoygyo',
         b'rpygrbgoggyygyygrr',
         b'ybpoobrpyoppgorybp',
         b'ybogoyrpyypbgrgyby',
         b'rpygrggryrpyypoybp',
         b'goygoyypggryyporpy',
         b'goyypyypggoorpyypr',
         b'ybogoroobrpyyyrypy',
         b'ybprpygrbybogorgoy',
         b'gyorpygopypggrrgrr',
         b'rpyybyybprpygrggry',
         b'rpyyopybogoyrpyogy',
         b'oopoyooyroobrpyopb',
         b'grggorrpygoyypyybp',
         b'rpygryybpgyrgoyrpy',
         b'googoyybpgrbrpyypo',
         b'grgrpygoygrgrpyypy',
         b'goygoygrbogboopoop',
         b'yppgryypbyprgrogyr',
         b'ypryproobybggrrgog',
         b'ybyoopoyooggoopppp']

# we wern't sure if this was big/little endian or 0/1 indexed, so this made it super simple to
# change on the fly.
table = bytes.maketrans(b'roygbp',
                        b'012345')

trbadge = []
for row in badge:
    newrow = []
    row = row.translate(table)
    for i in range(0, 18, 3):
        try:
            n = int(row[i:i + 3], 6)
        except ValueError as e:
            # a few data entry errors, and this told us where to look for them.
            print(e)
            print("row {}, i {}".format(row, i))
        newrow.append(n)
    trbadge.append(newrow)

pprint(trbadge)

for row in trbadge:
    for n in row:
        print(chr(n), end='')

print()

"""
the above gives a url, which if trimmed (the ppp doesn't match the pattern):
http://www.knjfmxff.club/19/

at first, it displayed a list of people. I've added their birthdays:

Long Distance Puzzle

Ada Lovelace        12/10/1815
Neal Stephenson     10/31/1959
Charles Babbage     12/26/1791
Nikola Tesla        07/10/1856
Stephen Hawking     01/08/1942
Niklaus Wirth       02/15/1934
Galileo Galilei     02/15/1564
Al Gore             03/31/1948
Marie Curie         11/07/1867
Daniel Trejo        05/16/1944
Aristotle           06/19/0384 (BC)

adding the digits of the birthdays multiple times...

"""

bdays = ["12101815",
         "10311959",
         "12261791",
         "07101856",
         "01081942",
         "02151934",
         "02151564",
         "03311948",
         "11071867",
         "05161944",
         "06190384"]


def sumdigits(s):
    s = str(s)
    sum = 0
    for c in s:
        sum += int(c)
    return sum

for bday in bdays:
    sum = sumdigits(bday)
    while sum > 9:
        sum = sumdigits(sum)
    print(sum, end="")
print()


"""
the above gives us a phone number.

12217762434

this number is incorrect. We aren't sure if the algorithm is correct.
the page changed sometime on friday night to give us the number
13217792124

when called, it gives this url:
https://iesnah.com/z/

that gives us score.png
"""

"""
score.png is music in c scale. 7 bit hint at the bottom means we are looking at
the distance between the notes.

if we only pay attention to when the notes rise (1) and fall (0) in each bar, we get:
1110100
1110100
1110100
1111000
-------
1110011
0101111
0101111
0101111
-------
1100010
1101001
1110100
0101110
-------
1101100
1111001
0101111
0110010
-------
1011001
1000010
0110001
1011010
-------
0110101
0110010
"""

bars = [0b1110100,
        0b1110100,
        0b1110100,
        0b1111000,
        0b1110011,
        0b0101111,
        0b0101111,
        0b0101111,
        0b1100010,
        0b1101001,
        0b1110100,
        0b0101110,
        0b1101100,
        0b1111001,
        0b0101111,
        0b0110010,
        0b1011001,
        0b1000010,
        0b0110001,
        0b1011010,
        0b0110101,
        0b0110010]

print("".join([chr(c) for c in bars]))

"""
the above gives us a url
bit.ly/2YB1Z52
which redirects us to

https://youreinvited.to/a/party/4.6692/ saved to party.html

this gives us some assembler (party.asm) when run with nasm drops the text
that is the key on that page.
"""

print(
"""
  _______________________________________
/ Congratulations! You have solved the   \\
| invitation puzzles; now it's time for  |
| the Challenge party. We are looking    |
| forward to greeting you at the Hard    |
| Rock Hotel on Saturday, August 10th at |
| 9pm in the Real World Penthouse in the |
\ Casino Tower - Room #1168.             /
 ----------------------------------------
\                             .       .
 \                           / `.   .' "
  \                  .---.  <    > <    >  .---.
   \                 |    \  \ - ~ ~ - /  /    |
         _____          ..-~             ~-..-~
        |     |   \~~~\.'                    `./~~~/
       ---------   \__/                        \__/
      .'  O    \     /               /       \  "
     (_____,    `._.'               |         }  \/~~~/
      `----.          /       }     |        /    \__/
            `-.      |       /      |       /      `. ,~~|
                ~-.__|      /_ - ~ ^|      /- _      `..-'
                     |     /        |     /     ~-.     `-. _  _  _
                     |_____|        |_____|         ~ - . _ _ _ _ _>
"""
)
