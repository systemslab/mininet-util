#!/usr/bin/python
from util.monitor import monitor_ss
import argparse

parser = argparse.ArgumentParser(description="Monitor socket statistics")
parser.add_argument('--dir', '-d',
                    dest="odir",
                    action="store",
                    help="Directory to store outputs",
                    required=True)

parser.add_argument('-n',
                    dest="node_name",
                    action="store",
                    help="node name",
                    required=True)

parser.add_argument('--port', '-p',
                    dest="port",
                    action="store",
                    help="port",
                    required=True)

parser.add_argument('--interval', '-i',
                    dest="interval",
                    action="store",
                    help="time interval between statistics",
                    required=True)


args = parser.parse_args()

monitor_ss(args.port, args.interval, '{}/ss_{}.txt'.format(args.odir, args.node_name)):
