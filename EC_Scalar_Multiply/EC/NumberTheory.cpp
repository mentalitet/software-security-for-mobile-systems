#include <stdlib.h>
#include "BigInteger.hpp"

namespace Cryptography {


    BigInteger modulo (BigInteger m, BigInteger n) {
        if (m >= 0) {
            return m % n;
        }
        else {
            BigInteger mModN = m % n;
            mModN = abs(mModN);
            return (n - mModN) % n;
        }
    }

    /* Find the inverse of a number x mod n such that
     * x*i mod n = 1 where i is the inverse of x mod n.
     */
    BigInteger* inverseMod(BigInteger x, BigInteger n) {
        return new BigInteger(BI_ModInv(x, n));
    }

}