#include "point.hpp"

class EllipticCurve
{
public:
    EllipticCurve();
    EllipticCurve(BigInteger a, BigInteger b, BigInteger M);
    // Find all points in the elliptic curve defined
    void calculatePoints();
    // Scalar multiplication returns a point X = kP
    Point scalarMultiply(BigInteger k, Point P, char* time);
    Point scalarMultiplyRDP(BigInteger * k, Point P, int size, BigInteger * D, int sizeD);
    // Scalar multiplication where the input is NAF representation
    Point scalarMultiplyNAF(BigInteger * k, Point P, int size);
    // Returns A + B
    Point add(Point A, Point B);
    ~EllipticCurve();
    // ostream handler: print this ellitpic curve equation
    friend std::ostream& operator <<(std::ostream& os, const EllipticCurve& ec);

private:
    bool time;
    BigInteger a, b; // points for elliptic curve equation
    BigInteger M; // module
    // Calculate the slope of two points
    BigInteger findSlope(BigInteger x1, BigInteger y1, BigInteger x2, BigInteger y2);
};