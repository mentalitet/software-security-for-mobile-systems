#include <cstdlib>
#include <iostream>
#include <cmath>

#include "point.hpp"
#include "BigInteger.hpp"

using namespace std;


// Empty Constructor
Point::Point() : x(0), y(0)
{
}

Point::Point (BigInteger x, BigInteger y)
{
    this->x = x;
    this->y = y;
}

// Deconstructor
Point::~Point()
{
}

// Getters
BigInteger Point::getX()
{
    return x;
}

BigInteger Point::getY()
{
    return y;
}

// Setters
void Point::setX(BigInteger x)
{
    this->x = x;
}

void Point::setY(BigInteger y)
{
    this->y = y;
}

// Negate a point by flipping the sign of y value of the point
void Point::negate(){
    this->y.sign *= -1;
}

// ostream handler: print this point
std::ostream& operator <<(std::ostream& os, const Point& p)
{
    return (os << "(" << p.x << ", " << p.y << ")");
}