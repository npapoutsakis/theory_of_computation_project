CORRECTS_ONES = correct1.la correct2.la

COLOR_GREEN = \033[32m
COLOR_RED = \033[31m
COLOR_RESET = \033[0m

all:
	bison -d -v -r all myanalyzer.y -Wcounterexamples
	flex mylexer.l
	gcc -o mycompiler lex.yy.c myanalyzer.tab.c cgen.c -lfl

	@echo "\nRunning tests..."
	@passed=0; \
	failed=0; \
	for example in $(CORRECTS_ONES); do \
		./mycompiler < $$example >/dev/null; \
		if [ -f c_file.c ]; then \
			output_file=$$(basename $$example .la).c; \
			mv c_file.c $$output_file; \
			if gcc -o $$(basename $$output_file .c) $$output_file lambdalib.h -I. >/dev/null; then \
				echo "✔️ $(COLOR_GREEN) Passed - Your program is syntactically correct! $(COLOR_RESET)- $$example"; \
				passed=$$((passed + 1)); \
			else \
				echo "❌ $(COLOR_RED) Failed $(COLOR_RESET)- $$example: Couldn't be compiled!"; \
				failed=$$((failed + 1)); \
			fi; \
		else \
			echo "❌ $(COLOR_RED) Failed $(COLOR_RESET)- $$example: Couldn't create .c file!"; \
			failed=$$((failed + 1)); \
		fi; \
	done; \
	echo "\nTests completed: $$passed passed, $$failed failed.\n"

clean:
	rm -rf lex.yy.c myanalyzer.tab.c myanalyzer.tab.h myanalyzer.output mycompiler correct1 correct2 correct1.c correct2.c
