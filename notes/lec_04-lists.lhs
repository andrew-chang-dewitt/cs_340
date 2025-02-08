> import Distribution.Simple.Utils (xargs)
> import Distribution.SPDX (LicenseId(MPL_2_0))
> import Debug.Trace

lists
=====

haskell has a built in list type, which (using haskell type notation) can be
defined as:

                 [t] = [] | t : [t]
                 ^   ^ ^  ^ ^ ^ ^
  a list of `t`s |   | |  | | | | any list of `t`s
  ----------------   | | OR | | ------------------
         is equal to | |    | | _cons_ with
         ------------- |    | -------------
         an empty list |    | any `t`
         ---------------    ---------

  where,

    `:` (the _cons_, or _construct_) operator, used to prepend a value (LHS) to
        the front of a list (RHS):
          a : [b, c, d] => [a, b, c, d]

we can use this cons operator to construct lists:

> l1 :: [Int]
> l1 = 3 : []
> l2 :: [ [Int] ]
> l2 = (3 : []) : []
> l3 :: [ [Int] ]
> l3 = (4 : (3 : [])) : (( 3 : [] ): [])


infinite lists
--------------

because haskell is lazily evaluated, infinite lists are not only possible, but
easy

> ones :: [Int]
> ones = 1 : ones     -- => [ 1, 1, 1, ... ]
> ones5 = take 5 ones -- => [ 1, 1, 1, 1, 1 ]
> onesh = head ones   -- => 1

with that, we can make functions that generate infinite lists

> repeat' :: a -> [a]
> repeat' x = x : repeat' x
> tens = repeat' 10 -- => [10, 10, 10, ... ]

a useful construct that utilizes this pattern:

> from5to10 = [5 .. 10] -- => [5,6,7,8,9,10]

this `[a .. b]` notation is actually just syntactic sugar for a function,
`enumFrom`. let's reimplement it ourselves:

> enumFrom' :: Enum a => a -> [a]

note `Enum` is a typeclass for enumerable types, aka numbers or anything else
that implements a *successor* function, `succ`

> enumFrom' x = x : enumFrom' (succ x)
> from5 = enumFrom' 5                 -- => [ 5, 6, 7, ... ]
> from5to10' = take 6 ( enumFrom' 5 ) -- => [ 5, 6, 7, 8, 9, 10 ]


list comprehensions
-------------------

a handy notation for generating lists succinctly, uses a syntax like
mathematical set builders:

```
{ 2x | x ⋹ ℕ } ≡ { 2, 4, 6, ... }
```

we can do the same thing with list comprehensions (v similar to python):

> evens = [ 2*x | x <- [1..] ]                -- => [ 2, 4, 6, ... ]

using a predicate, we can redefine `evens`:

> evens' = [ x | x <- [1..], x `mod` 2 == 0 ] -- => [ 2, 4, 6, ... ]

:::note
while list comprehensions are powerful & concise, they can become difficult to
read as they grow in complexity. keep that in mind when using them & defer
to writing more standard functions when things move beyond simple.
:::

\### some more list comp. practice: factors of n

> factors :: Integral a => a -> [a]
> factors n = [ i | i <- [1 .. n], n `mod` i == 0 ]
> factOf18 = factors 18 -- => [ 1, 2, 3, 6, 9, 18 ]

we can, of course, write this using a list generator function instead:

> factors' :: Integral a => a -> [a]
> factors' n = gen 1
>   where div i = n `mod` i == 0 -- div :: Integral a => a -> Bool
>         gen i | i == n = [i]   -- gen :: Integral a => a -> [a]
>               | div i = i : gen (i + 1)
>               | otherwise = gen (i + 1)
> factOf18' = factors' 18 -- => [ 1, 2, 3, 6, 9, 18 ]

but imo that's much much more difficult to write & read in comparison to the
list comprehension version

\### another example: cartesian product

> cartesianProduct :: [a] -> [b] -> [(a,b)]
> cartesianProduct xs ys = [(x, y) | x <- xs, y <- ys ]
> cartProd1to4abc = cartesianProduct [1..4] "abc"

\### final ex: list concatenation

> concat' :: [[a]] -> [a]
> concat' ls = [x | l <- ls, x <- l]
> concatEx = concat' [[1,2,3],[4,5,6],[7,8,9]]
> -- => [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]

:::warn
in this example, order matters. if you try the following, the compiler will complain:

```haskell wont-compile
concat' :: [[a]] -> [a]
concat' ls = [x | x <- l, l <- ls]
```

failing to compile with the following error:

```
  Variable not in scope: l :: [a]
 |
 | > concat' ls = [x | x <- l, l <- ls]
 |                          ^
```
:::

some useful builtin list functions
----------------------------------

:::note
the following is quoted from lecture notes provided by prof Michael Lee [on
GH][1]
:::

| The "Prelude" module defines many useful list functions (some of which we
| implemented above). They include:
|
|   - Basic operations:
|
|     head :: [a] -> a
|     tail :: [a] -> [a]
|     null :: [a] -> Bool
|     length :: [a] -> Int
|     last :: [a] -> a
|     (++) :: [a] -> [a] -> [a]
|     (!!) :: [a] -> Int -> a
|
|   - Building lists:
|
|     repeat :: a -> [a]
|     replicate :: Int -> a -> [a]
|     cycle :: [a] -> [a]
|
|   - Lists -> Lists:
|
|     concat :: [[a]] -> [a]
|     reverse :: [a] -> [a]
|     zip :: [a] -> [b] -> [(a,b)]
|
|   - Extracting sublists:
|
|     take :: Int -> [a] -> [a]
|     drop :: Int -> [a] -> [a]
|     splitAt :: Int -> [a] -> ([a], [a])
|     break :: (a -> Bool) -> [a] -> ([a], [a])
|
|   - Class specific:
|
|     elem :: Eq a => a -> [a] -> Bool
|     maximum :: Ord a => [a] -> a
|     minimum :: Ord a => [a] -> a
|     sum :: Num a => [a] -> a
|     product :: Num a => [a] -> a
|     lines :: String -> [String]
|     words :: String -> [String]
|
| :::note:
| many of these functions operate on a type class that includes lists and
| other recursive data types (We'll see how this works later.)
| :::


list processing fns
-------------------

\### pattern matching

we can pattern match on list args. remember how we can use pattern matching for redefining `fst` for tuples:

> fst' :: (a, b) -> a
> fst' (x, _) = x

this works because `(y, z)` is the *tuple constructor*, meaning we can unpack,
or destructure, a tuple using the constructor in the lhs of a pattern matching
expression.

we can use something similar with the *list constructor*, `y : ys`, for redefining `head`:

> head' :: [a] -> a
> head' (x:_) = x
> headOnes = head' ones -- => 1

and also works for `tail`:

> tail' :: [a] -> [a]
> tail' (_:xs) = xs
> tailOnes = tail' ones -- => 1 : ones

we can compute the length of a list w/ pattern matching:

> length' :: [a] -> Int
> length' [] = 0
> length (x:xs) = 1 + length' xs

or get the last element:

> last' :: Show a => [a] -> a
> last' (x: []) = x
> last' (x: xs) = traceShow x ( last' xs )


references
==========

[1]: https://github.com/cs340ppp/lectures/blob/ddf49ae3538c288d8059833189dfd5fe558a9b35/src/Lect04.lhs#L118C1-L161C67
