"""
red orange yellow green blue purple

each line is 18 chars long

3 char chunks divided by 3


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
         b'ybyoopoyooggoopppp'
         ]

table = bytes.maketrans(b'roygbp',
                        b'012345')

trbadge = []
for row in badge:
    newrow = []
    row = row.translate(table)
    for i in range(0, 18, 3):
        try:
            n = int(row[i:i+3], 6)
        except ValueError as e:
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
here are the birthdays from "Long distance puzzle"

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
"""
