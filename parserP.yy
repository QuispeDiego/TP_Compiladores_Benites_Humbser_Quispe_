%skeleton "lalr1.cc"
%require "3.7.5"
%defines

%define api.token.raw

%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires{
    #include <string>
    #include <cmath>
    class driver;
}

%param {driver& drv}

%locations

%define parse.trace
%define parse.error detailed
%define parse.lac full

%code{
    #include "driverP.hh"
}

%define api.token.prefix{TOK_}
%token
    ASSING "="
    MINUS "-"
    PLUS "+"
    STAR "*"
    SLASH "/"
    POWER "^"
    LPAREN "("
    RPAREN ")"
    ;

%token <std::string> IDENTIFIER "identifier"
%token <double> NUMBER "number"
%token <std::string> STRING "string"
%nterm <double> exp

%printer { yyo << $$; } <*>;
%printer { yyo << "\"" << $$ << "\""; } <STRING>;

%%
    %start unit;
    unit:
        assignments exp             {drv.result = $2;}
        ;

    assignments:
        %empty                    {}
        | assignments assignment  {}
        ;

    assignment:
        "identifier" "=" exp    {drv.variables[$1] = $3;}
        ;

    %left "+" "-";
    %left "*" "/";
    %left "^";

    exp:
        "number"
      | "identifier"             {$$ = drv.variables[$1];}
      | exp "+" exp              {$$ = $1 + $3;}
      | exp "-" exp              {$$ = $1 - $3;}
      | exp "*" exp              {$$ = $1 * $3;}
      | exp "/" exp              {$$ = $1 / $3;}
      | exp "^" exp              {$$ = pow($1, $3);}
      | "(" exp ")"              {$$ = $2;}
      ;
%%

void yy::parser::error(const location_type& l, const std::string& m){
    std::cerr << l << ": " << m << std::endl;
}