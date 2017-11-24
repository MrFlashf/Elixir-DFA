# Elixir Deterministic Finite-state Automaton (no wage)

Elixir application representating a simple Deterministic Finite-state Automaton (DFA)

### Instalation:

 1. Clone repository
 2. cd dfa
 3. Get libs: `mix deps.get`
 4. Compile: `mix escript.build`
 
 5. To get docs: `mix docs`
 6. Running tests: `mix test`
 
### Instruction:
 - `./dfa {file_name} < ATT`
 - `{file_name}` is a name of the file that contains words to check,
 and `AT&T` is a file containing automaton rules.
 - For example `./dfa simple.arg < simple.in`
