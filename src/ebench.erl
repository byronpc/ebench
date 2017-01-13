-module(ebench).
-author('byronpc1@gmail.com').
-export([start/5, start/3]).

start(Module, Function, Args, Processes, Count) ->
  Fun = fun() -> apply(Module, Function, Args) end,
  start(Fun, Processes, Count).

start(Fun, Processes, Count) ->
  process_flag(trap_exit, true),
  ExpectedResult = Fun(),
  Self = self(),
  F = fun() ->
    SubResult = lists:foldl(fun(_Y, {S, F}) ->
      case Fun() of
        ExpectedResult -> {S + 1, F};
        _ -> {S, F + 1}
      end
    end, {0, 0}, lists:seq(1, Count)),
    Self ! SubResult
  end,
  {Time, {Success, Failures}} = timer:tc(fun() ->
    lists:foreach(fun(_X) ->
      spawn(F)
    end, lists:seq(1, Processes)),
    wait_responses({0, 0}, Processes)
  end),
  io:format("~nBenchmark Complete~nTime Completed: ~pms~nSuccess: ~p~nFailure: ~p~nRate: ~p queries per second~n~n", [Time/1000, Success, Failures, Success/(Time/1000000)]),
  {Time, Success, Failures}.

wait_responses({Success, Failure}, 0) ->
  {Success, Failure};

wait_responses({Success, Failure}, Count) ->
  receive
    {'EXIT', _, _} ->
      wait_responses({Success, Failure}, Count -1);
    {S1, F1} ->
      wait_responses({Success + S1, Failure + F1}, Count -1)
  end.