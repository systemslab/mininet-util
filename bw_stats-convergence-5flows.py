#!/usr/bin/python

total_time = float(9*5)

# optimal bandwidths
o = [
# 5th flow
     (100000000 * 5) / total_time,
# 4th flow
     (125000000 * 5 +
      100000000 * 5 +
      125000000 * 5) / total_time,
# 3rd flow
     (166666666.67 * 5 +
      125000000 * 5 +
      100000000 * 5 +
      125000000 * 5 +
      166666666.67 * 5) / total_time,
# 2nd flow
     (250000000 * 5 +
      166666666.67 * 5 +
      125000000 * 5 +
      100000000 * 5 +
      125000000 * 5 +
      166666666.67 * 5 +
      250000000 * 5) / total_time,
# 1st flow
     (500000000 * 5 +
      250000000 * 5 +
      166666666.67 * 5 +
      125000000 * 5 +
      100000000 * 5 +
      125000000 * 5 +
      166666666.67 * 5 +
      250000000 * 5 +
      500000000 * 5) / total_time,
     ]

print "optimal average bandwidths over entire period {}".format(["{:.2f}".format(float(bw)/pow(10, 6)) for bw in o])

results = dict()

# ideal
results["ideal"] = o

# Capped at one 10th, but fair otherwise
results["capped"] = [
# 5th flow
     (10000000 * 5) / total_time,
# 4th flow
     (12500000 * 5 +
      10000000 * 5 +
      12500000 * 5) / total_time,
# 3rd flow
     (16666666.67 * 5 +
      12500000 * 5 +
      10000000 * 5 +
      12500000 * 5 +
      16666666.67 * 5) / total_time,
# 2nd flow
     (25000000 * 5 +
      16666666.67 * 5 +
      12500000 * 5 +
      10000000 * 5 +
      12500000 * 5 +
      16666666.67 * 5 +
      25000000 * 5) / total_time,
# 1st flow
     (50000000 * 5 +
      25000000 * 5 +
      16666666.67 * 5 +
      12500000 * 5 +
      10000000 * 5 +
      12500000 * 5 +
      16666666.67 * 5 +
      25000000 * 5 +
      50000000 * 5) / total_time,
     ]

# One greedy flow
results["greedy"] = [(500000000 * total_time) / total_time,
# 2nd flow
     0,
# 3rd flow
     0,
# 4th flow
     0,
# 5th flow
     0,
     ]

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

        if len(t) == 0:
            continue

        x = [f/o[i] for i, f in enumerate(t)]
        print "{}: normalized bandwidths over entire period {}".format(scenario, ["{:.2f}".format(float(bw)) for bw in x])

        j = float(sum(x) ** 2) / (len(x) * sum([s ** 2 for s in x]))
    
        print "{}: fraction of ideal aggregate bandwidth {:.2f}".format(scenario, sum(t)/sum(o))
        print "{}: JFI {:.4f}".format(scenario, j)
        print

