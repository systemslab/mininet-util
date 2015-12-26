#!/usr/bin/python

total_time = float(30)

# optimal bandwidths
o = [
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     500000000 / 20,
     ]

print "optimal average bandwidths over entire period {}".format(["{:.2f}".format(float(bw)/pow(10, 6)) for bw in o])

results = dict()

# ideal
results["ideal"] = o

# Capped at one 10th, but fair otherwise
results["capped"] = [
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     50000000 / 20,
     ]

# One greedy flow
results["greedy"] = [
     500000000,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     ]

def print_stats(results):
    scenarios = results.keys()
    scenarios.sort()
    for scenario in scenarios:
        t = results[scenario]
        x = [f/o[i] for i, f in enumerate(t)]
        j = float(sum(x) ** 2) / (len(x) * sum([s ** 2 for s in x]))
    
        print "{}: bandwidths over entire period {}".format(scenario, ["{:.2f}".format(float(bw)/pow(10, 6)) for bw in t])
        print "{}: normalized bandwidths over entire period {}".format(scenario, ["{:.2f}".format(float(bw)) for bw in x])
        print "{}: fraction of ideal aggregate bandwidth {:.2f}".format(scenario, sum(t)/sum(o))
        print "{}: JFI {:.4f}".format(scenario, j)
        print
