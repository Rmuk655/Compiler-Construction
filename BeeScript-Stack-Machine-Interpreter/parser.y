%{
    #include <bits/stdc++.h>
    using namespace std;
    int yylex (void);
    void yyerror (char const * s){
        fprintf (stderr, "%s\n", s);
    }
    #define MAX_STACK_SIZE 100
    ifstream file("script.txt");
    ofstream out("output.txt");
    deque<int> st;
    extern char* runtime_input;
    int pos = 0;

    // Problems are reported on stderr and the instruction is skipped, so
    // output.txt only ever holds program output.
    void warn(const char *op, const char *why){
        fprintf(stderr, "beescript: %s ignored: %s\n", op, why);
    }
    bool push(int v){
        if(st.size() >= MAX_STACK_SIZE){ warn("push", "stack is full"); return false; }
        st.push_back(v);
        return true;
    }
    bool files_ok(){
        if(!file.is_open()){ fprintf(stderr, "beescript: cannot open script.txt\n"); return false; }
        if(!out.is_open()){ fprintf(stderr, "beescript: cannot write output.txt\n"); return false; }
        return true;
    }
%}

%union{
    int int_val;
}

%token <int_val> TOK_NUMBER;
%token TOK_AVIATE
%token TOK_BEE
%token TOK_BLACK
%token TOK_BARRY
%token TOK_ROTATE
%token TOK_ROTAT
%token TOK_YELLOW

%%

input:
    %empty
    | input instruction
    ;

instruction:
    TOK_AVIATE TOK_NUMBER {
        char c = 0;
        bool found = $2 >= 1;
        file.clear(); file.seekg(0);
        for(int i = 0; found && i < $2; i++){ if(!file.get(c)){ found = false; } }
        if(found){ push((int)c); } else { warn("AVIATE", "position is outside script.txt"); }
    }
    | TOK_BEE { if(st.empty()){ warn("BEE", "stack is empty"); } else { push(st.back()); } }
    | TOK_BLACK {
        if(st.empty()){ warn("BLACK", "stack is empty"); }
        else { int x = st.back(); st.pop_back(); char c = (char) x; if(x <= 0) { out << x; } else{ out << c; } }
    }
    | TOK_BARRY { if(st.size() >= 2){ int A = st[st.size() - 1]; st.pop_back(); int B = st[st.size() - 1]; st.pop_back(); st.push_back(B - A); } }
    | TOK_ROTATE { if(st.empty()){ warn("ROTATE", "stack is empty"); } else { int x = st[0]; st.pop_front(); st.push_back(x); } }
    | TOK_ROTAT { if(st.empty()){ warn("ROTAT", "stack is empty"); } else { int x = st[st.size() - 1]; st.pop_back(); st.push_front(x); } }
    | TOK_YELLOW {
        if(runtime_input == NULL || runtime_input[pos] == '\0'){ warn("YELLOW", "no input left"); }
        else { push((int)(unsigned char)runtime_input[pos++]); }
    }
    ;

%% 