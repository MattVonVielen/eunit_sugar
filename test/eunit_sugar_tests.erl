-module(eunit_sugar_tests).

-compile([export_all]).

-include_lib("eunit/include/eunit.hrl").

-define(EXAMPLE_MODULE, module_for_testing_fixtures).

fixture_for_entire_module_without_setup_and_teardown_test() ->
    ExpectedSortedFunctions = [ fun ?EXAMPLE_MODULE:F/0 || F <- [
        prefix1_setup, prefix1_test_function_1, prefix1_test_function_2,
        prefix2_setup, prefix2_test_function_1, prefix2_test_function_2,
        setup, test_function1, test_function2
    ]],

    {foreach, _, _, Tests} = eunit_sugar:fixture(?EXAMPLE_MODULE),

    ?assertEqual(ExpectedSortedFunctions, lists:sort(Tests)).

fixture_for_entire_module_with_setup_and_teardown_calls_setup_and_teardown_test() ->
    {foreach, Setup, Teardown, _} = eunit_sugar:fixture(?EXAMPLE_MODULE, setup, teardown),

    erlang:put(setup_called, undefined),
    erlang:put(teardown_called, undefined),
    Setup(),
    Teardown(some_argument),

    ?assertEqual(true, erlang:get(setup_called)),
    ?assertEqual({true, some_argument}, erlang:get(teardown_called)).

fixture_for_entire_module_with_setup_and_teardown_omits_setup_and_teardown_test() ->
    ExpectedSortedFunctions = [ fun ?EXAMPLE_MODULE:F/0 || F <- [
        prefix1_setup, prefix1_test_function_1, prefix1_test_function_2,
        prefix2_setup, prefix2_test_function_1, prefix2_test_function_2,
        test_function1, test_function2
    ]],

    {foreach, _, _, Tests} = eunit_sugar:fixture(?EXAMPLE_MODULE, setup, teardown),

    ?assertEqual(ExpectedSortedFunctions, lists:sort(Tests)).

fixture_with_atom_prefix_without_setup_and_teardown_selects_functions_by_prefix_test() ->
    ExpectedSortedFunctions = [ fun ?EXAMPLE_MODULE:F/0 || F <- [
        prefix1_setup, prefix1_test_function_1, prefix1_test_function_2
    ]],

    {foreach, _, _, Tests} = eunit_sugar:fixture(?EXAMPLE_MODULE, prefix1),

    ?assertEqual(ExpectedSortedFunctions, lists:sort(Tests)).

fixture_with_string_prefix_without_setup_and_teardown_selects_functions_by_prefix_test() ->
    ExpectedSortedFunctions = [ fun ?EXAMPLE_MODULE:F/0 || F <- [
        prefix2_setup, prefix2_test_function_1, prefix2_test_function_2
    ]],

    {foreach, _, _, Tests} = eunit_sugar:fixture(?EXAMPLE_MODULE, "prefix2"),

    ?assertEqual(ExpectedSortedFunctions, lists:sort(Tests)).

fixture_with_atom_prefix_with_setup_and_teardown_selects_functions_by_prefix_omitting_setup_and_teardown_test() ->
    ExpectedSortedFunctions = [ fun ?EXAMPLE_MODULE:F/0 || F <- [
        prefix1_test_function_1, prefix1_test_function_2
    ]],

    {foreach, _, _, Tests} = eunit_sugar:fixture(?EXAMPLE_MODULE, prefix1, prefix1_setup, prefix1_teardown),

    ?assertEqual(ExpectedSortedFunctions, lists:sort(Tests)).

fixture_with_string_prefix_with_setup_and_teardown_selects_functions_by_prefix_omitting_setup_and_teardown_test() ->
    ExpectedSortedFunctions = [ fun ?EXAMPLE_MODULE:F/0 || F <- [
        prefix2_test_function_1, prefix2_test_function_2
    ]],

    {foreach, _, _, Tests} = eunit_sugar:fixture(?EXAMPLE_MODULE, "prefix2", prefix2_setup, prefix2_teardown),

    ?assertEqual(ExpectedSortedFunctions, lists:sort(Tests)).

fixture_with_atom_prefix_with_setup_and_teardown_calls_setup_and_teardown_test() ->
    {foreach, Setup, Teardown, _} = eunit_sugar:fixture(?EXAMPLE_MODULE, prefix1, prefix1_setup, prefix1_teardown),

    erlang:put(prefix1_setup_called, undefined),
    erlang:put(prefix1_teardown_called, undefined),
    Setup(),
    Teardown(some_argument),

    ?assertEqual(true, erlang:get(prefix1_setup_called)),
    ?assertEqual({true, some_argument}, erlang:get(prefix1_teardown_called)).

fixture_with_string_prefix_with_setup_and_teardown_calls_setup_and_teardown_test() ->
    {foreach, Setup, Teardown, _} = eunit_sugar:fixture(?EXAMPLE_MODULE, "prefix2", prefix2_setup, prefix2_teardown),

    erlang:put(prefix2_setup_called, undefined),
    erlang:put(prefix2_teardown_called, undefined),
    Setup(),
    Teardown(some_argument),

    ?assertEqual(true, erlang:get(prefix2_setup_called)),
    ?assertEqual({true, some_argument}, erlang:get(prefix2_teardown_called)).

parameterized_fixture_for_entire_module_with_setup_and_teardown_calls_setup_and_teardown_test() ->
    {foreach, Setup, Teardown, _} = eunit_sugar:parameterized_fixture(?EXAMPLE_MODULE, setup, teardown),

    erlang:put(setup_called, undefined),
    erlang:put(teardown_called, undefined),
    Setup(),
    Teardown(some_argument),

    ?assertEqual(true, erlang:get(setup_called)),
    ?assertEqual({true, some_argument}, erlang:get(teardown_called)).

parameterized_fixture_for_entire_module_with_setup_and_teardown_omits_setup_and_teardown_test() ->
    ExpectedSortedFunctions = [ {with, [fun ?EXAMPLE_MODULE:F/1]} || F <- [
        parameterized_test_function1, parameterized_test_function2,
        prefix1_parameterized_test_function_1, prefix1_parameterized_test_function_2, prefix1_teardown,
        prefix2_parameterized_test_function_1, prefix2_parameterized_test_function_2, prefix2_teardown
    ]],

    {foreach, _, _, Tests} = eunit_sugar:parameterized_fixture(?EXAMPLE_MODULE, setup, teardown),

    ?assertEqual(ExpectedSortedFunctions, lists:sort(Tests)).

parameterized_fixture_with_atom_prefix_with_setup_and_teardown_selects_functions_by_prefix_omitting_setup_and_teardown_test() ->
    ExpectedSortedFunctions = [ {with, [fun ?EXAMPLE_MODULE:F/1]} || F <- [
        prefix1_parameterized_test_function_1, prefix1_parameterized_test_function_2
    ]],

    {foreach, _, _, Tests} = eunit_sugar:parameterized_fixture(?EXAMPLE_MODULE, prefix1, prefix1_setup, prefix1_teardown),

    ?assertEqual(ExpectedSortedFunctions, lists:sort(Tests)).

parameterized_fixture_with_string_prefix_with_setup_and_teardown_selects_functions_by_prefix_omitting_setup_and_teardown_test() ->
    ExpectedSortedFunctions = [ {with, [fun ?EXAMPLE_MODULE:F/1]} || F <- [
        prefix2_parameterized_test_function_1, prefix2_parameterized_test_function_2
    ]],

    {foreach, _, _, Tests} = eunit_sugar:parameterized_fixture(?EXAMPLE_MODULE, "prefix2", prefix2_setup, prefix2_teardown),

    ?assertEqual(ExpectedSortedFunctions, lists:sort(Tests)).

parameterized_fixture_with_atom_prefix_with_setup_and_teardown_calls_setup_and_teardown_test() ->
    {foreach, Setup, Teardown, _} = eunit_sugar:parameterized_fixture(?EXAMPLE_MODULE, prefix1, prefix1_setup, prefix1_teardown),

    erlang:put(prefix1_setup_called, undefined),
    erlang:put(prefix1_teardown_called, undefined),
    Setup(),
    Teardown(some_argument),

    ?assertEqual(true, erlang:get(prefix1_setup_called)),
    ?assertEqual({true, some_argument}, erlang:get(prefix1_teardown_called)).

parameterized_fixture_with_string_prefix_with_setup_and_teardown_calls_setup_and_teardown_test() ->
    {foreach, Setup, Teardown, _} = eunit_sugar:parameterized_fixture(?EXAMPLE_MODULE, "prefix2", prefix2_setup, prefix2_teardown),

    erlang:put(prefix2_setup_called, undefined),
    erlang:put(prefix2_teardown_called, undefined),
    Setup(),
    Teardown(some_argument),

    ?assertEqual(true, erlang:get(prefix2_setup_called)),
    ?assertEqual({true, some_argument}, erlang:get(prefix2_teardown_called)).
