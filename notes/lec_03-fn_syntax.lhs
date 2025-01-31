import GHC.ExecutionStack (SrcLoc(sourceColumn))
import qualified Distribution.Simple.Utils as aside
import qualified Distribution.Simple.Utils as aside
import Distribution.Simple.Command (helpCommandUI)
import Language.Haskell.TH (clause)
Functions
===

def syntax
---

- defined as an equation
- should always include a type sig

> nand :: Bool -> Bool -> Bool
> -- name arg1 arg2 = <body>
> nand x y = not (x && y)

pattern matching
---

we can write pattern matching expressions like functions:

> -- there's a builtin `not`, so we call ours not'
> not' True = False
> not' False = True

```
ghci> not' True
False
ghci> not' False
True
```

this function checks if the value given equals the value on the lefthand side in the arg position, if it matches, then the righthand side is executed
if it doesn't match, then we go to the next pattern defined (processed top down) & attempt to match there

we can use pattern matching to define recursive functions & their base cases:

> fib :: Integer -> Integer
> fib 0 = 0
> fib 1 = 1
> fib n = fib (n - 1) + fib (n - 2)

:::aside.warning
A word of warning: this definition is easy to read, almost exactly as defined in mathematics; however, it's also one of the most inefficient implementations
:::

let's revisit our `nand` definition above, this time using pattern matching

> nand' True False = True
> nand' False True = True
> nand' False False = True
> nand' True True = False

notice how the first three patterns all evaluate to the same result, this should tell us we can actually simplify this a lot:

> nand'' True True = False
> nand'' _ _ = True

:::aside.info
Note: we use the special arg name `_` to indicate that we actually don't use either value on the righthand side, we'll just always return True w/out any regard for any values that pass the first pattern. essentially, this definition uses `nand'' _ _ = ...` as a catch-all or final case in the pattern matching statement
:::

some more pattern matching exercises--let's deconstruct values:

> fst' :: (a,b) -> a
> fst' (x,_) = x

this notation has only one arg: a two-tuple where we've deconstructed it into two variables, `x` & `_`

an example of calculating the distance between two points:

> distance :: (Floating a) => (a,a) -> (a,a) -> a
> distance (x1,y1) (x2,y2) = sqrt( (x1 - x2)^2 + (y1 - y2)^2 )

> mapTup :: (a -> b) -> (a,a) -> (b,b)
> mapTup f (x, y) = (f x, f y)

```
ghci> mapTup (\x -> x*2) (4,8)
(8,16)
ghci> mapTup (*2) (4,8) -- note (*2) is equiv to \x -> x*2
(8,16)
ghci> mapTup show (4,8)
("4","8")
```

> foo :: (a, (b, c)) -> ((a, (b, c)), (b, c), (a, b, c))
> foo (x, (y, z)) = ( (x, ( y, z )), (y, z), (x, y, z))

guards
---

not pattern matching, but another way of conditionally selecting a righthand side to execute based on logic about the args given

fib rewritten using guards:

> fib' :: Integer -> Integer
> fib' n | n == 0 = 0
>        | n == 1 = 1
>        | otherwise = fib (n - 1) + fib (n - 2)

this feature might be your useful in other scenarios.
an example where we convert a percentage score to a letter grade:

> pctToLtr :: (Ord a, Num a) => a -> Char
> pctToLtr n | n >= 90 = 'A'
>            | n >= 80 = 'B'
>            | n >= 70 = 'C'
>            | n >= 60 = 'D'
>            | otherwise = 'E'

where clause
---

creates a var local to the function

> c2h :: (Floating a, Ord a) => a -> String
> c2h c | f >= 100  = "hot"
>       | f >= 70   = "comfortable"
>       | f >= 50   = "cool"
>       | otherwise = "cold"
>       where f = c2f c

> c2f :: (Floating a) => a -> a
> c2f c = (c * 1.8) + 32

some constructs that will help
===

:::aside.info
note: all in this section are _expressions_, not statements or definitions
:::

`if-then-else`
---

Syntax: 

  `if e1 then e2 else e3`
  where e1, e2, & e3 all evaluate to the same type

an example, finding which of a given value is closest to a given source

> closer :: (Floating a, Ord a) => (a,a) -> (a,a) -> (a,a) -> (a,a)
> closer s d1 d2 = if distance s d1 < distance s d2 then d1 else d2

`case ... of`
---

> quadName :: (Int, Int) -> String
> quadName p = case quadrant p of 1 -> "All"
>                                 2 -> "Science"
>                                 3 -> "Teachers"
>                                 4 -> "Crazy"
>                                 0 -> "Origin"

> quadrant :: (Int, Int) -> Int
> quadrant (x, y) | x > 0 && y > 0 = 1
>                 | x < 0 && y > 0 = 2
>                 | x < 0 && y < 0 = 3
>                 | x > 0 && y > 0 = 4
>                 | otherwise      = 0

`let ... in`
---

`let` creates local variables (bindings) in fns to be used in a final `in` expression

an example: calculating roots of a quadratic equation

> quadRoots :: Double -> Double -> Double -> (Double, Double)
> quadRoots a b c = let disc = b^2 - 4*a*c
>                       x1 = (-b + sqrt disc) / 2*a
>                       x2 = (-b - sqrt disc) / 2*a
>                   in (x1, x2)
