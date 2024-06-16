* 참조
[confer](https://learnyousomeerlang.com/contents)

* how to run with erl command without rebar3

make file named 'Emakefile'

```
{'src/*', [debug_info,
			{i, "src"},
			{i, "include"},
			{outdir, "ebin"}]}.
```

erl -make

erl -pa ebin/

* rebar3
