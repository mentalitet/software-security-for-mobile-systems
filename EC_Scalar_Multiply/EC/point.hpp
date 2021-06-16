#include "BigInteger.hpp"
class Point
{
    public:
        Point();
        Point(BigInteger x, BigInteger y);
        // Point(Point &&) = default;
        // Point(const Point &) = default;
        // Point &operator=(Point &&) = default;
        // Point &operator=(const Point &) = default;
        ~Point();
        // Getters
        BigInteger getX();
        BigInteger getY();

        // Setters
        void setX(BigInteger x);
        void setY(BigInteger y);

        // Negate a point by changing the sign of y value
        void negate();

        // ostream handler: print this point
        friend std::ostream& operator <<(std::ostream& os, const Point& p);

    private:
        BigInteger x;
        BigInteger y;
};

