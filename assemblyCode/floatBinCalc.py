
def binToDec(binNum):
    decNum = 0
    power = 0
    while binNum>0:
        decNum += 2 **power* (binNum%10)
        binNum //=10
        power += 1
    return decNum

def getExp(binaryExp, isNormalized):
    expDigits = len(binaryExp)
    binaryExpInt = int(binaryExp)
    exp = 0
    expBias = 2**(expDigits - 1) - 1
    if isNormalized:
        exp = binToDec(binaryExpInt) - expBias
    else :
        exp = 1 - expBias
    
    print ("BIAS: " + str(expBias))
    return exp

def getMantissa(mantissa, isNormalized):
    man = 0
    index = 1
    for exp in mantissa:
        if(exp == '1'):
            man += 2**(-index)
        # print(man)
        index+=1

    if isNormalized == True:
        man += 1
    return man

def getIsNormalized(binaryExp):
    intNum = int(binaryExp)
    # print(intNum)
    isNormalized = True if (intNum != 0) else False
    return isNormalized

def getResults(signal, mantissa, binaryExp):
    isNormalized = getIsNormalized(binaryExp)
    print ("isNormalized: " + str(isNormalized))
    man = getMantissa(mantissa, isNormalized)
    exp = getExp(binaryExp, isNormalized)

    print ("M: " + str(man))
    print ("E: " + str(exp))
    dec = signal * man * 2**(exp)

    print("DEC: " + str(dec))


def run():
    signal = 1
    mantissa = "001"
    binaryExp = "00000"
    getResults(signal, mantissa, binaryExp)

run()



