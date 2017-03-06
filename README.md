# eunit_sugar

* Builds on eunit's [fixtures](http://erlang.org/doc/apps/eunit/chapter.html#Fixtures) to make implementing test suites easier by reducing boilerplate code.
* Designed to work alongside existing eunit tests.

## API

##### fixture
fixture(Module) -> FixtureTuple  
fixture(Module, Prefix) -> FixtureTuple  
fixture(Module, Setup, Teardown) -> FixtureTuple  
fixture(Module, Prefix, Setup, Teardown) -> FixtureTuple

Types:
* Module = atom()
* Prefix = atom() | string()
* Setup = atom()
* Teardown = atom()
* FixtureTuple = tuple()

Declares a group of functions from _Module_ as test functions that will be run as eunit test functions.  
When _Prefix_ is present, only functions whose name match _Prefix_ with an arity of 0 will be selected for inclusion. When _Prefix_ is not present, every function in the module with an arity of 0 (with a few exceptions) will be selected.  
_Setup_ and _Teardown_ are functions that will be run before and after each test function in the group.

##### parameterized_fixture
parameterized_fixture(Module, Setup, Teardown) -> FixtureTuple  
parameterized_fixture(Module, Prefix, Setup, Teardown) -> FixtureTuple  

Types:
* Module = atom()
* Prefix = atom() | string()
* Setup = atom()
* Teardown = atom()
* FixtureTuple = tuple()

Declares a group of functions from _Module_ as test functions that will be run as eunit test functions.  
When _Prefix_ is present, only functions whose name match Prefix with an arity of 1 will be selected for inclusion. When _Prefix_ is not present, every function in the module with an arity of 1 (with a few exceptions) will be selected.  
_Setup_ and _Teardown_ are functions that will be run before and after each test function in the group.  
__parameterized_fixture__ differs from __fixture__ in that _Setup_ will be run before each test function and the output will be passed to the test function as an argument.

Resources:

* [Official eunit documentation](http://erlang.org/doc/apps/eunit/chapter.html)
* [Fixtures section of the official documentation](http://erlang.org/doc/apps/eunit/chapter.html#Fixtures)
* [Learn You Some Erlang's chapter on eunit](http://learnyousomeerlang.com/eunit)
* [Hoax](https://github.com/xenolinguist/hoax): Another erlang testing library that provides mocking and stubbing on top of __eunit_sugar__.
