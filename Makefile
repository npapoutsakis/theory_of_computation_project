EXAMPLES_DIR = lamda_examples
SINGLE_EXAMPLE = example.la

COLOR_GREEN = \033[32m
COLOR_RED = \033[31m
COLOR_RESET = \033[0m

all:
	bison -d -v -r all myanalyzer.y -Wcounterexamples
	flex mylexer.l
	gcc -o mycompiler lex.yy.c myanalyzer.tab.c cgen.c -lfl 
	@if [ -f $(SINGLE_EXAMPLE) ]; then \
		./mycompiler < $(SINGLE_EXAMPLE);\
		if [ -f c_file.c ]; then \
			if gcc -o c_file c_file.c lambdalib.h -I. 2>/dev/null; then \
				echo "✔️ $(COLOR_GREEN) Passed $(COLOR_RESET)- $(SINGLE_EXAMPLE)"; \
			else \
				echo "❌$(COLOR_RED) Failed $(COLOR_RESET)- $(SINGLE_EXAMPLE): Couldn't be compiled!"; \
			fi; \
		else \
			echo "❌$(COLOR_RED) Failed $(COLOR_RESET)- $(SINGLE_EXAMPLE): Couldn't create .c file!"; \
		fi; \
	fi


# Target to run and test all examples
test:
	bison -d -v -r all myanalyzer.y
	flex mylexer.l
	gcc -o mycompiler lex.yy.c myanalyzer.tab.c cgen.c -lfl

	@echo "\nRunning tests..."
	@passed=0; \
	failed=0; \
	for example in $(EXAMPLES_DIR)/*.la; do \
		./mycompiler < $$example > /dev/null 2>&1; \
		if [ -f c_file.c ]; then \
			if gcc -o c_file c_file.c lambdalib.h -I. 2>/dev/null; then \
				echo "✔️ $(COLOR_GREEN) Passed $(COLOR_RESET)- $$example"; \
				rm c_file.c c_file; \
				passed=$$((passed + 1)); \
			else \
				echo "❌$(COLOR_RED) Failed $(COLOR_RESET)- $$example: Couldn't be compiled!"; \
				failed=$$((failed + 1)); \
			fi; \
		else \
			echo "❌$(COLOR_RED) Failed $(COLOR_RESET)- $$example: Couldn't create .c file!"; \
			failed=$$((failed + 1)); \
		fi; \
	done; \
	echo "\nTests completed: $$passed passed, $$failed failed.\n"

clean:
	rm -rf lex.yy.c myanalyzer.tab.c myanalyzer.tab.h myanalyzer.output mycompiler c_file c_file.c