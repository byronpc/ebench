-module(ebench).
-author('byronpc1@gmail.com').
-export([start/5, start/3]).

start(Module, Function, Args, Processes, Count) ->
  Fun = fun() -> apply(Module, Function, Args) end,
  start(Fun, Processes, Count).

start(Fun, Processes, Count) ->
  ExpectedResult = Fun(),
  {Time, Result} = timer:tc(fun() ->
    plists:map(fun(_X) ->
      lists:foldl(fun(_Y, {S, F}) ->
        case Fun() of
          ExpectedResult -> {S + 1, F};
          _ -> {S, F + 1}
        end
      end, {0, 0}, lists:seq(1, Count))
    end, lists:seq(1, Processes))
  end),
  {Success, Failures} = lists:foldl(fun({S1, F1}, {S, F}) ->
    {S + S1, F + F1}
  end, {0, 0}, Result),
  io:format("~nBenchmark Complete~nTime Completed: ~pms~nSuccess: ~p~nFailure: ~p~nRate: ~p queries per second~n~n", [Time/1000, Success, Failures, Success/(Time/1000000)]),
  {Time, Success, Failures}.