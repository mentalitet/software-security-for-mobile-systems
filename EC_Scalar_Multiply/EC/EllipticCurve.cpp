#include <cstdlib>
#include <iostream>
#include <cstdio>
#include <cmath>
#include <map>
#include <sstream>

#include "EllipticCurve.hpp"
#include "NumberTheory.cpp"
#include "Project1/NumeralConverter.hpp"

using namespace std;
using namespace Cryptography;

EllipticCurve::EllipticCurve()
{
    EllipticCurve(1, 1, 17);
}

EllipticCurve::EllipticCurve(BigInteger a, BigInteger b, BigInteger M) : a(a), b(b), M(M) {
    time = true;
}

EllipticCurve::~EllipticCurve()
{
}

// Scalar multiplication returns a point X = kP
Point EllipticCurve::scalarMultiply(BigInteger k, Point P, char* time){
    Point Q = Point(0, 0); // Initalize a point to (0,0)

    stringstream buffer;
    buffer << k;
    string bin = NumeralConverter(NumeralConverter::NumSystem::DEC, buffer.str())
        .ConvertValue(NumeralConverter::NumSystem::BIN);

    clock_t begin_time = clock();
    for (int i = 0; i< bin.length(); i++) {
        Q = add(Q, Q);
        if (bin[i] == '1') {
            Q = add(Q, P);
        }
    }
    if (time)
        sprintf(time, "%f", float(clock() - begin_time) / CLOCKS_PER_SEC);
    return Q;
}

Point EllipticCurve::scalarMultiplyRDP(BigInteger * k, Point P, int size, BigInteger * D, int sizeD) {
    Point Q; // Initialize a point to (0, 0)
    Point R = P;
    std::map<BigInteger, Point> RDPMap;

    map<BigInteger, Point>::iterator it;
    time = false;
    for (int i = 0; i < sizeD; i++) {
        Point X = scalarMultiply(D[i], P, nullptr);
        RDPMap.insert(std::pair<BigInteger, Point>(D[i], X));
    }
    time = true;

    // for(it = RDPMap.begin(); it != RDPMap.end(); it++) {
    //     std::cout << it->first << " : " << it->second << std::endl;
    // }
    BigInteger index; // to store the index
    Point T;
    clock_t begin_time = clock();
    for(int i=0; i < size; i++) {
        index = k[size - 1 - i]; // Get the bits from most significant bit
        Q = add(Q, Q);
        if (index != 0) {
            if (index < 0) {
                T = RDPMap.at(abs(index));
                T.negate();
                Q = add(Q, T);
                T.negate();
            }
            else
                Q = add(Q, RDPMap.at(index));
        }
    }
    std::cout << "Time >> " << float( clock () - begin_time ) /  CLOCKS_PER_SEC << endl;
    return Q;
}

/* Algorithm used is the following:
 * Q = 0;
 * For i = l-1 to 0:
 *      Q = 2Q;
 *      if (ki == 1) then Q = Q+P
 *      if (ki == -1) then Q = Q-P
 * return Q
 */
Point EllipticCurve::scalarMultiplyNAF(BigInteger * k, Point P, int size) {
    Point Q; // Initialize a point to (0, 0)
    Point R = P;
    BigInteger index; // to store the index
    clock_t begin_time = clock();
    for(int i=0; i < size; i++) {
        index = k[size-1-i]; // Get the bits from most significant bit
        Q = add(Q, Q);
        if (index == 1) {
            Q = add(Q, R);
        }
        if(index == -1) {
            // Get the negative value of R
            R.negate();
            Q = add(Q, R);
            R.negate(); // Return R to positive
        }
    }
    std::cout << "Time >> " << float( clock () - begin_time ) /  CLOCKS_PER_SEC << endl;
    return Q;
}

// Returns A + B
Point EllipticCurve::add(Point A, Point B){
    // get all x and y values of points A and B
    BigInteger x1 = A.getX();
    BigInteger y1 = A.getY();
    BigInteger x2 = B.getX();
    BigInteger y2 = B.getY();

    // Check if point A or point B = 0;
    if (x1 == 0 && y1 == 0) {
        return B;
    }
    if (x2 == 0 && y2 == 0) {
        return A;
    }

    // get the slope of two points, it returns a point to the slope.
    BigInteger slopeValue = findSlope(x1, y1, x2, y2);
    // Check if the pointer is null
    if (slopeValue == NULL) {
        Point P(0, 0);
        return P;
    }
    BigInteger slope = slopeValue;

    BigInteger x3 = modulo(slope*slope - x1 - x2, M);
    BigInteger y3 = modulo(slope*(x1 - x3) - y1, M);

    Point P(x3, y3);

    return P;

}


/* This function finds the slope of two points
 * if the two points are equal, it means point doubling,
 * otherwise, it's point addition.
 * Point doubling: slope = (3*x1*x1 + a)/2*y1 % M
 * Point addition: slope = (y2-y1)/(x2-x1) % M
 */
BigInteger EllipticCurve::findSlope(BigInteger x1, BigInteger y1, BigInteger x2, BigInteger y2) {
    BigInteger slope = 0; // initialize a pointer to slope
    BigInteger numerator, denominator;
    // if the two points are equal, slope is for point doubling
    // else slope is for point addition operation.

    // ------------ POINT DOUBLING --------------
    if ((x1 == x2) && (y1 == y2)) {
        numerator = modulo(3*x1*x1 + a, M);
        denominator = modulo(2*y1, M);
    }
    // ------------ Point Addition --------------
    else {
        numerator = modulo(y2-y1, M);
        denominator = modulo(x2-x1, M);
    }
    if (denominator == 0) {
        return 0;
    }
    /* since slope is modular division, if the numerator and denominator
     * are not coprime, we need to multiply the numerator by the modular 
     * inverse of denominator.
     */
    BigInteger *inv = inverseMod(denominator, M);
    slope = *inv * numerator % M;
    delete inv;
    return slope;
}

// ostream handler: print this elliptic curve equation
std::ostream& operator <<(std::ostream& os, const EllipticCurve& ec)
{
    return (os << "y^2 = x^3 + " << ec.a << "x + " << ec.b <<
                " Mod " << ec.M);
}