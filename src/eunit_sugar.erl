-module(eunit_sugar).

%% API exports
-export([fixture/1, fixture/2, fixture/3, fixture/4]).
-export([parameterized_fixture/3, parameterized_fixture/4]).

%%====================================================================
%% API functions
%%====================================================================

fixture(Module) ->
    fixture_tuple(Module, 0, fun default_test_selector/1).

fixture(Module, Prefix) ->
    fixture_tuple(Module, 0, prefix_test_selector(Prefix)).

fixture(Module, Setup, Teardown) when is_atom(Setup), is_atom(Teardown) ->
    fixture_tuple(Module, 0, Setup, Teardown, setup_teardown_test_selector(Setup, Teardown)).

fixture(Module, Prefix, Setup, Teardown) when is_atom(Setup), is_atom(Teardown) ->
    fixture_tuple(Module, 0, Setup, Teardown, prefix_setup_teardown_test_selector(Prefix, Setup, Teardown)).

parameterized_fixture(Module, Setup, Teardown) when is_atom(Setup), is_atom(Teardown) ->
    fixture_tuple(Module, 1, Setup, Teardown, setup_teardown_test_selector(Setup, Teardown)).

parameterized_fixture(Module, Prefix, Setup, Teardown) when is_atom(Setup), is_atom(Teardown) ->
    fixture_tuple(Module, 1, Setup, Teardown, prefix_setup_teardown_test_selector(Prefix, Setup, Teardown)).

%%====================================================================
%% Internal functions
%%====================================================================

default_test_selector(Func) ->
    Name = atom_to_list(Func),
    Func =/= module_info andalso
        Func =/= test andalso
        (not lists:suffix("_test", Name)) andalso
        (not lists:suffix("_test_", Name)).

prefix_to_list(Prefix) when is_list(Prefix) -> Prefix;
prefix_to_list(Prefix) when is_atom(Prefix) -> atom_to_list(Prefix).

prefix_test_selector(Prefix) ->
    fun(F) ->
        default_test_selector(F) andalso lists:prefix(prefix_to_list(Prefix), atom_to_list(F))
    end.

setup_teardown_test_selector(Setup, Teardown) ->
    fun(F) ->
        default_test_selector(F) andalso F =/= Setup andalso F =/= Teardown
    end.

prefix_setup_teardown_test_selector(Prefix, Setup, Teardown) ->
    fun(F) ->
        default_test_selector(F) andalso F =/= Setup andalso F =/= Teardown andalso
            lists:prefix(prefix_to_list(Prefix), atom_to_list(F))
    end.

fixture_tuple(Module, Arity, Selector) ->
    fixture_tuple(Module, Arity, fun() -> ok end, fun(_) -> ok end, Selector).

fixture_tuple(Module, Arity, UserSetup, UserTeardown, Selector) when is_atom(UserSetup), is_atom(UserTeardown) ->
    fixture_tuple(Module, Arity, fun Module:UserSetup/0, fun Module:UserTeardown/1, Selector);
fixture_tuple(Module, Arity, UserSetup, UserTeardown, Selector) when is_function(UserSetup), is_function(UserTeardown) ->
    Tests = [fun Module:F/Arity || {F, A} <- Module:module_info(exports), A == Arity, Selector(F) == true],
    TestList = case Arity of
                   0 -> Tests;
                   1 -> [{with, [T]} || T <- Tests]
               end,
    {foreach, UserSetup, UserTeardown, TestList}.
