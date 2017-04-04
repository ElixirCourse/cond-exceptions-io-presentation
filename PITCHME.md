## Conditionals
### if, cond, case, etc.

Андрей Дренски

#HSLIDE

### Няколко думи...

#HSLIDE

### if, unless

#HSLIDE

```elixir
if <condition> do
  <do_stuff>
else
  <do_other_stuff>
end
```
#HSLIDE

```elixir
def fib(n) when is_integer(n) and n >= 0 do
  if n == 0 or n == 1 do
    n
  else
    fib(n-1) + fib(n-2)
  end
end
```

#HSLIDE

Може и по-кратко:

```elixir
if (<condition>), do: <do_stuff>, else: <do_other_stuff>
```

#HSLIDE

`if` си има и брат-близнак - `unless`.
Той обаче не е по-малко зъл!
Следните две парчета код са еквивалентни:
<table>
<tr>
<td><pre lang="elixir">
if &lt;condition&gt; do
  &lt;do_stuff&gt;
else
  &lt;do_other_stuff&gt;
end
</pre></td>
<td><pre lang="elixir">
unless &lt;condition&gt; do
  &lt;do_other_stuff&gt;
else
  &lt;do_stuff&gt;
end
</pre></td>
</tr></table>

#HSLIDE

Тъй като `if` и `unless` са макроси, които приемат "клаузите" си като (почти) key-value двойки и ги оценяват *мързеливо*, може всяка една от двете клаузи да бъде изпусната.

#HSLIDE

### cond

#HSLIDE

```elixir
cond do
  <condition1> -> <do_stuff>
  <condition2> -> <do_other_stuff>
  ...
  <conditionN> -> <do_whatever_you_want>
end
```

#HSLIDE

```elixir
def fib(n) do
  cond do
    n == 0 or n == 1 -> n
    true -> fib(n-1) + fib(n-2)
  end
end
```

#HSLIDE

### case

#HSLIDE

```elixir
case <expr> do
  <pattern1> -> <do_stuff>
  <pattern2> -> <do_other_stuff>
  ...
  <patternN> -> <do_whatever_you_want>
end
```

#HSLIDE

```elixir
def fib(n) do
 case n do
   0 -> 0
   1 -> 1
   n when is_integer(n) and n > 1 -> fib(n-1) + fib(n-2)
  end
end
```

#HSLIDE

### ... and mighty pattern matching:

```elixir
def fib(0) do: 0
def fib(1) do: 1
def fib(n) when is_integer(n) and n > 1, do: fib(n-1) + fib(n-2)
```

#HSLIDE

```elixir
# iei
```