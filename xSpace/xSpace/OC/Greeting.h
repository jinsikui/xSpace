

#ifndef Greeting_hpp
#define Greeting_hpp

#include <stdio.h>
#include <string>

class Greeting {
    std::string greeting;
public:
    Greeting();
    std::string greet();
};

#endif
