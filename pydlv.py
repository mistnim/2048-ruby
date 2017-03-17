#!/usr/bin/env python3
import os

# input(0, 2, 4, 2, 0, 0, 64, 8, 0, 16, 8, 32, 4, 4, 8, 2).
a = [0, 2, 4, 2, 0, 0, 64, 8, 0, 16, 8, 32, 4, 4, 8, 2]
input = 'input(' + ', '.join(str(x) for x in a) + ').'

print(int(os.popen("echo \"" + input + "\" | cat - tables.pl logic.pl | idlv --stdin applymove.py | clasp | grep '^Optimization\s:' | cut -f 3 -d ' '").read()))
