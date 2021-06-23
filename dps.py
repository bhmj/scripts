#!/usr/bin/python
# -*- coding: utf-8 -*-

import fileinput
import re

MARGIN = 2

# split line to columns
def split_line(line, cols):
    split = []
    for i, col in enumerate(cols):
        if i < len(cols)-1:
            split.append(line[col:cols[i+1]].strip())
        else:
            split.append(line[col:].strip())
    return split

cols = []
lines = []
first_line = True
for line in fileinput.input():
    if first_line:
        # find column starting positions
        divider = 99
        for pos,c in enumerate(line):
            if c == ' ':
                divider = divider + 1
            else:
                if divider > 2:
                    cols.append(pos)
                divider = 0
        lines.append( split_line(line, cols) )
        first_line = False
    else:
        # split rest of the lines to columns
        lines.append( split_line(line, cols) )

# cleanup logic
port_pairs = re.compile(r'(\d{2,5})->(\d{2,5})')
port_dups = re.compile(r'(\d{2,5}->\d{2,5}), (\d{2,5}->\d{2,5})')
port_dups2 = re.compile(r'(\d{2,5}), (\d{2,5})')
for l, line in enumerate(lines):
    for c, col in enumerate(line):
        col = re.sub(r'…', '..', col)
        col = re.sub(r'0.0.0.0:', '', col)
        col = re.sub(r'127.0.0.1:', '', col)
        col = re.sub(r':::', '', col)
        col = re.sub(r'\/tcp', '', col)
        for m in re.finditer(port_pairs, col):
            if m.group(1) == m.group(2):
                col = col.replace(m.group(1)+"->"+m.group(2), m.group(1))
        for m in re.finditer(port_dups, col):
            if m.group(1) == m.group(2):
                col = col.replace(m.group(1)+", "+m.group(2), m.group(1))
        for m in re.finditer(port_dups2, col):
            if m.group(1) == m.group(2):
                col = col.replace(m.group(1)+", "+m.group(2), m.group(1))
        col = re.sub(r'->', ' -> ', col)
        col = re.sub(r' seconds', 's', col)
        col = re.sub(r' minutes', 'm', col)
        col = re.sub(r' hours', 'h', col)
        col = re.sub(r' days', 'd', col)
        col = re.sub(r' weeks', 'w', col)
        lines[l][c] = col.strip()

# dense columns
col_with = []
for l, line in enumerate(lines):
    for c, col in enumerate(line):
        if len(col_with) < c+1:
            col_with.append(0)
        if col_with[c] < len(col) + MARGIN:
            col_with[c] = len(col) + MARGIN

# output in table-like form
for l, line in enumerate(lines):
    for c, col in enumerate(line):
        print(col.ljust(col_with[c])),
    print

