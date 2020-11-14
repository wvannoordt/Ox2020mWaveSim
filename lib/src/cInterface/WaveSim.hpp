#include "extDef.h"
#include <iostream>
void Initialize(void)
{
    std::cout << "HI" << std::endl;
    InitializeInternal();
}

int AddTest(int a, int b)
{
    return a+b;
}