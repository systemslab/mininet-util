#!/usr/bin/python

import sys

bw = float(sys.argv[1]) * pow(10, 6)
n = int(sys.argv[2])
total_time = float(sys.argv[3])

# optimal bandwidths
o = [ bw / n ] * n

print "optimal average bandwidths over entire period {}".format(["{:.2f}".format(float(bw)/pow(10, 6)) for bw in o])

results = dict()

# ideal
results["ideal"] = o

# Capped at one 10th, but fair otherwise
results["capped"] = [ i * 0.10 for i in o ]

# One greedy flow
results["greedy"] = [ bw ]
results["greedy"].extend([0.0] * (n-1))

def print_stats(results):
    scenarios = results.keys()
    scenarios.sort()
    for scenario in scenarios:
        t = results[scenario]

        lt = len(t)
        lo = len(o)
        if lt < lo:
            t.extend([0.0] * (lo -lt))

        print "{}: bandwidths over entire period {}".format(scenario, ["{:.2f}".format(float(bw)/pow(10, 6)) for bw in t])

        x = [f/o[i] for i, f in enumerate(t)]
        print "{}: normalized bandwidths over entire period {}".format(scenario, ["{:.2f}".format(float(bw)) for bw in x])

        j = float(sum(x) ** 2) / (len(x) * sum([s ** 2 for s in x]))
    
        print "{}: fraction of ideal aggregate bandwidth {:.2f}".format(scenario, sum(t)/sum(o))
        print "{}: JFI {:.4f}".format(scenario, j)
        print
