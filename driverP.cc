#include "driverP.hh"

driver::driver(): trace_parsing(false), trace_scanning(false){
    //variables["!info"] = "Este es un lenguaje de programacion creado por unirversitarios de la UPC";
    variables["uno"] = 1.0;
}

double driver::parse(const std::string& f){
    file = f;
    location.initialize(&file);
    scan_begin();
    yy::parser parse(*this);
    parse.set_debug_level(trace_parsing);
    double res = parse();
    scan_end();

    return res;
}

void driver::set_variable(const std::string& name, void* value){
    variables[name] = value;
}

void* driver::get_variable(const std::string& name){
    return variables[name];
}