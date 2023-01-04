#!/usr/bin/python
# -*- coding: utf-8 -*-

import fileinput, re

MARGIN = 2

# Split line to columns
def split_line(line, cols):
    split = []
    for i, col in enumerate(cols):
        if i < len(cols)-1:
            split.append(line[col:cols[i+1]].strip())
        else:
            split.append(line[col:].strip())
    return split

# Appends port interval. Expects the final call with port == "" to properly finalize merge procedure.
# args:
#   joined : resulting array
#   first  : current first interval bound
#   last   : current last interval bound
#   port   : port or port interval (8080 or 8080-8082)
# returns:
#   first, last, joined : new values
def append_interval(joined, first, last, port):
    interval = port.split("-")
    if len(interval) < 2:
        if first:
            joined.append(first + "-" + last)
        return "", "", joined + [port]
    else:
        left, right = interval[0], interval[1]
        if last and int(last) + 1 == int(left):
            return first, right, joined
        else:
            if first:
                joined.append(first + "-" + last)
            return left, right, joined

# Merges port intervals: 8080-8082, 8082-8090 becomes 8080-8090.
def merge_intervals(ports):
    first, last = "", ""
    joined_ports = []
    for port in ports + [""]:
        first, last, joined_ports = append_interval(joined_ports, first, last, port)
    return joined_ports

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

# search patterns
ports_pattern = "\d{2,5}(-\d{2,5})?" # 8080 or 8080-8082
port_mapping_pattern = "(" + ports_pattern + ")->(" + ports_pattern + ")"
port_mapping = re.compile(port_mapping_pattern)
for l, line in enumerate(lines):
    for c, col in enumerate(line):
        # simple replacements
        col = re.sub(r'…', '..', col)
        col = re.sub(r'0.0.0.0:', '', col)
        col = re.sub(r'127.0.0.1:', '', col)
        col = re.sub(r':::', '', col)
        col = re.sub(r'\/tcp', '', col)

        # replace port mapping duplicates:
        # 8080->8080  becomes  8080
        # 8080-8082->8080-8082  becomes  8080-8082
        for m in re.finditer(port_mapping, col):
            if m.group(1) == m.group(3):
                col = col.replace(m.group(1)+"->"+m.group(3), m.group(1))

        # merge intervals: 8080-8082, 8082-8090  becomes  8080-8090
        port_entries = col.split(", ")
        if len(port_entries) > 1:
            deduplicated_ports = list(dict.fromkeys(port_entries))
            joined_ports = merge_intervals(deduplicated_ports)
            col = ", ".join(filter(None, joined_ports))

        # more simple replacements
        col = re.sub(r'->', ' -> ', col)
        col = re.sub(r'About a minute', '~1m', col)
        col = re.sub(r'About an hour', '~1h', col)
        col = re.sub(r' seconds', 's', col)
        col = re.sub(r'Less than', '<', col)
        col = re.sub(r'a second', '1s', col)
        col = re.sub(r' second', 's', col)
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
        print(col.ljust(col_with[c]), end=""),
    print()
