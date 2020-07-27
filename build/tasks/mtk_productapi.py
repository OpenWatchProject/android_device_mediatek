import os,re,sys
import argparse
import logging

logging.basicConfig(stream=sys.stdout,format='%(asctime)s - %(name)s - %(levelname)s: %(message)s')
logger = logging.getLogger('mtk_productapi.py')
logger.setLevel(logging.INFO)

def diffList(a,b,c,m):
    return_code = 0
    used = []
    current1 = []
    current2 = []
    check = []

    for line in open(str(a)):
        used.append(line)
    for line in open(str(b)):
        current1.append(line)
    for line in open(str(c)):
        current2.append(line)

#    check = list(set(used).difference(set(current)))
    check1 = [x for x in used if x not in current1]
    check = [x for x in check1 if x not in current2]
    if len(check) == 0:
        logger.info('{} has no violation ProductApi.'.format(str(m)))
    else:
        difftxt = '{}/diff.txt'.format(os.path.dirname(str(a)))
        logger.error('{} has {} violation ProductApi: \n{} --> {}'.format(str(m),len(check),check,difftxt))
        diff_txt = open(difftxt,'a+')
        diff_txt.writelines(map(lambda x: x,sorted(check)))
        return_code = 1
    sys.exit(return_code)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-u','--used',help='Used API list')
    parser.add_argument('-c1','--current1',help='mediatek current API list')
    parser.add_argument('-c2','--current2',help='aosp current API list')
    parser.add_argument('-m','--module',help='APK path')
    args = parser.parse_args()
    diffList(args.used,args.current1,args.current2,args.module)


if __name__ == '__main__':
    main()
