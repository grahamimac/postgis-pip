# Program to read in Taxi CSV data and output just the point lat lon

import sys

def subset_data(fname):
	c = 0
	with open(fname, 'r') as f, open(fname.split('.')[0] + '_out.csv', 'w') as f_out:
		for line in f:
			if c > 0 and line != '\r\n':
				a = line.split(',')
				if len(a[5]) > 0 and len(a[6]) > 0:
					f_out.write('SRID=4269;POINT(' + a[5][:14] + ' ' + a[6][:14] + ')\n')
			c += 1

if __name__ == '__main__':
	subset_data(sys.argv[1])