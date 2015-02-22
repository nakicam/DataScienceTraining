#include "soci/soci.h"
#include "soci/oracle/soci-oracle.h"
#include <iostream>
#include <istream>
#include <ostream>
#include <string>
#include <exception>

int main()
try
{
    soci::session sql(soci::oracle, "service=orcl user=abc password=abc");

    int count;
    sql << "select count(*) from A", soci::into(count);
    std::cout << "We have " << count << " entries in the A.\n";

    const std::string name = "arg 86";
    std::string team;
    soci::indicator ind;
    sql << "select name from A where name = :name", soci::into(team, ind), soci::use(name);

    if (ind == soci::i_ok)
    {
        std::cout << "The team is " << team << '\n';
    }
    else
    {
        std::cout << "There is no team for " << name << '\n';
    }
}
catch (std::exception const &e)
{
    std::cerr << "Error: " << e.what() << '\n';
}

