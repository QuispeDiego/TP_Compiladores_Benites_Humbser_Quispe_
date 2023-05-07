#ifndef __DRIVER_H__
#define __DRIVER_H__

#include "parserP.hh"
#include <map>
#include <string>

#define YY_DECL \
    yy::parser::symbol_type yylex(driver& drv)

class driver{
public:
    std::map<std::string,void*> variables;
    void* result;
    std::string file;
    bool trace_parsing;
    bool trace_scanning;
    yy::location location;
    
public:
    driver();
    double parse(const std::string& f);
    void scan_begin();
    void scan_end();
    void set_variable(const std::string& name, void* value);
    void* get_variable(const std::string& name);
};

YY_DECL;

#endif