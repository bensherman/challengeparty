# caezarschallenge

This is the badge photo and the code I used to decode it. The URL in the purple text was hard to get programatically.
I guessed at the letters I didn't know until I got something that worked.

all-hand.txt is the digits from the badge.  I first used an OCR program to get them all, then hand modified it to ensure correctness. I comma seperated each field, then made a second value in the same line explaining which color each one was. This could have been done with a better data structure, but I really wanted to be able to visualize it while I was working on it.

here is the output:
```
y:  This is a red herring but you are probably going to figure out what it says anyway. Maybe I should make it worth your while. Maybe I should link to some 0day, or some porn. Probably not.
c:  Brought to you by Caezar, Almus, and Seric
p:  Qdrk rk btq j pol dopprbs <dqqy://xx.vwqobthtsw.xtn/>
p:  This is not a red herring <http://cc.bytenology.com/>
r:  w3lc0m370c43z4r5ch4ll3n632016
```
