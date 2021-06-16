#ifndef NUMERALCONVERTER_HPP
#define NUMERALCONVERTER_HPP

#include <string>
#include <cmath>
#include "../BigInteger.hpp"

class NumeralConverter
{
    public:
        enum NumSystem { BIN, OCT, DEC, HEX };

        NumeralConverter(NumSystem system, std::string value);
        bool valueGood();
        std::string ConvertValue(NumSystem target);

    private:
        std::string inputValue;
        NumSystem valueSystem;

        BigInteger decodeDigit(char digit);

        std::string decToSys(BigInteger sys);
        std::string sysToDec(BigInteger sys);
};

#endif
