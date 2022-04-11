This is a tiny little Java app to demonstrate Pratt parsing. For a full explanation, see [this blog post](http://journal.stuffwithstuff.com/2011/03/19/pratt-parsers-expression-parsing-made-easy/).



运行和输出（Lua 5.4 & luajit 2.1）：
$ cd src
$ lua Main.lua ; luajit Main.lua
Passed all 24 tests.
Passed all 24 tests.

utils 外的代码文件是原 Java 版的对应移植，
utils 中是辅助功能代码，以及为了适配原 Java 逻辑所需功能。

类继承和接口实现关系（OO 实现说明见 oo.lua 注释）：
BantamParser extends Parser
interface
    Exp:
        AssignExp CallExp CondExp NameExp
        BinaryExp PostfixExp PrefixExp
    InfixOpParselet:
        AssignParselet BinaryParselet CallParselet CondParselet
        PostfixParselet
    PrefixOpParselet:
        GroupParselet NameParselet PrefixParselet

Token   Pre/I P --> PLet(L,T) & Exp --> Output
------------------------------------------------------------------------
EOF
NAME    Pre     --> Name  (_, T)    --> T
=       I   1   --> Assign(L, _)    --> (L = eP-)
?       I   2   --> Cond  (L, _)    --> (L ? e0 : eP-)  --> :
(       Pre     --> Group           --> e0              --> )
(       I   8   --> Call  (L, _)    --> L(e0*)          --> ,)

!~+-    Pre 6   --> Pre   (_, T)    --> (T eP)

!       I   7   --> Post  (L, T)    --> (L T)

+-      I   3   --> Bin   (L, T)    --> (L T eP)
*/      I   4   --> Bin   (L, T)    --> (L T eP)

^       I   5   --> Bin   (L, T)    --> (L T eP-)
------------------------------------------------------------------------
Pre: 前缀类型， I: 中缀类型， P: 优先级，大数优先；
    后缀表达式用中缀实现；
PLet(L,T) & Exp: parselet 和 expression 类名（无后缀），
    L 和 T 分别是 parselet 的参数 left 表达式 和 token ；
    Group 无 Exp ；
Output: Exp 的输出，其中标点符号原样输出，L 和 T 与上同，* 是 0 或多个，
    e0 是解析所有优先级的 token 得到一个表达式，
    eP 是解析 T 的优先级以上的 token 得到一个表达式，
    eP- 是降低一级，即包括同级 token ，用于右结合；
最后一列是关联的 token 。
