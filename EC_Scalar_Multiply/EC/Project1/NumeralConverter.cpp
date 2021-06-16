#include "NumeralConverter.hpp"
#include <sstream>

NumeralConverter::NumeralConverter(NumSystem system, std::string value)
{
    valueSystem = system;
    inputValue = value;
}

//Check if input string contains correct digits
bool NumeralConverter::valueGood()
{
    switch(valueSystem)
    {
        case NumSystem::BIN:
            for(unsigned int i = 0; i < inputValue.length(); i++)
                if(inputValue[i] != '0' && inputValue[i] != '1')
                    return false;
            break;

        case NumSystem::OCT:
            for(unsigned int i = 0; i < inputValue.length(); i++)
                if(inputValue[i] < '0' || inputValue[i] > '7')
                    return false;

            break;

        case NumSystem::DEC:
            for(unsigned int i = 0; i < inputValue.length(); i++)
                if(inputValue[i] < '0' || inputValue[i] > '9')
                    return false;

            break;

        case NumSystem::HEX:
            for(unsigned int i = 0; i < inputValue.length(); i++)
                if((inputValue[i] < '0' || inputValue[i] > '9') &&
                   (inputValue[i] < 'A' || inputValue[i] > 'F'))
                        return false;
            break;
    }

    return true;
}

std::string NumeralConverter::ConvertValue(NumSystem target)
{
    switch(valueSystem)
    {
        case NumSystem::BIN:
            if(target == NumSystem::BIN)
                return inputValue;

            if(target == NumSystem::DEC)
                return sysToDec(2);

            if(target == NumSystem::OCT)
            {
                inputValue = sysToDec(2); //Convert from BIN to DEC and from DEC to OCT
                return decToSys(8);
            }

            if(target == NumSystem::HEX)
            {
                inputValue = sysToDec(2); //Convert from BIN to DEC and from DEC to HEX
                return decToSys(16);
            }

            break;

        case NumSystem::OCT:
            if(target == NumSystem::BIN)
            {
                inputValue = sysToDec(8); 
                return decToSys(2);
            }

            if(target == NumSystem::DEC)
                return sysToDec(8);

            if(target == NumSystem::OCT)
                return inputValue;

            if(target == NumSystem::HEX)
            {
                inputValue = sysToDec(8); 
                return decToSys(16);
            }

            break;

        case NumSystem::DEC:
            if(target == NumSystem::BIN)
                return decToSys(2);

            if(target == NumSystem::OCT)
                return decToSys(8);

            if(target == NumSystem::DEC)
                return inputValue;

            if(target == NumSystem::HEX)
                return decToSys(16);

        break;

        case NumSystem::HEX:
            if(target == NumSystem::BIN)
            {
                inputValue = sysToDec(16);
                return decToSys(2);
            }

            if(target == NumSystem::OCT)
            {
                inputValue = sysToDec(16);
                return decToSys(8);
            }


            if(target == NumSystem::DEC)
                return sysToDec(16);

            if(target == NumSystem::HEX)
                return inputValue;

        break;
    }

    //Return 0 to fix warning
    return 0;
}

//Decode digit and return BigInteger value
BigInteger NumeralConverter::decodeDigit(char digit)
{   
    //We have digit greater than 10 (A, B, C etc.)
    if(digit >= 65)
        //'A' has value 65 in ASCII, so 65 - 55 is 10, 'B' has value 66 so 66 - 55 is 11 etc.
        return digit-55;
    else
    {
        std::string val;
        val += digit;
        return std::stoi(val);
    }
}

//Convert from any system to DEC
std::string NumeralConverter::sysToDec(BigInteger sys)
{
    BigInteger val = 0;
    int power = inputValue.length()-1;

    for(unsigned int i = 0; i < inputValue.length(); i++)
    {
        val += decodeDigit(inputValue[i]) * powych(sys, power);
        power--;
    }

    std::stringstream buffer;
    buffer << val;
    return buffer.str();
}

//Convert from DEC to any system
std::string NumeralConverter::decToSys(BigInteger sys)
{
    char digits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

    std::string sysValTemp, sysVal;
    BigInteger decVal = BigInteger(inputValue);

    while(decVal != 0)
    {
        sysValTemp += digits[(int)(decVal % sys).to_int64()];

        decVal /= sys;
    }

    //Revert value
    for (int i = sysValTemp.length() - 1; i >= 0; i--)
        sysVal += sysValTemp[i];

    return sysVal;
}
