# ebench
Yet another simple erlang function benchmarking tool

## functions

```erlang
start(Module, Function, Args, Processes, RequestsPerProcess)
start(AnnonymousFunction, Processes, RequestsPerProcess)
```

## usage

```erlang
ebench:start(io, format, ["hello world~n"], 10, 10).
```

Benchmark Complete<br />
Time Completed: 367.277ms<br />
Success: 100<br />
Failure: 0<br />
Rate: 272.27406017801275 queries per second<br />
{367277,100,0}

```erlang
ebench:start(fun() -> io:format("hello world~n") end, 10, 10).
```

Benchmark Complete<br />
Time Completed: 334.672ms<br />
Success: 100<br />
Failure: 0<br />
Rate: 298.8000191232012 queries per second<br />
{334672,100,0}
