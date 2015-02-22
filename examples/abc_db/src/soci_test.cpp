#include "soci/soci.h"
#include "soci/oracle/soci-oracle.h"
#include <iostream>
#include <istream>
#include <ostream>
#include <string>
#include <exception>

using namespace soci;
using namespace std;

int main()
try
{
    soci::session sql(oracle, "service=orcl user=abc password=abc");

    int count;
    sql << "select count(*) from A", into(count);
    cout << "We have " << count << " entries in the A.\n";

    const std::string name = "arg 86";
    string team;
    soci::indicator ind;
    sql << "select name from A where name = :name", into(team, ind), use(name);

    if (ind == i_ok)
    {
        cout << "The team is " << team << '\n';
    }
    else
    {
        cout << "There is no team for " << name << '\n';
    }
}
catch (exception const &e)
{
    cerr << "Error: " << e.what() << '\n';
}

