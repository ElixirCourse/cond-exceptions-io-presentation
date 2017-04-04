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

Може и по-кратко:

```elixir
if (<condition>), do: <do_stuff>, else: <do_other_stuff>
```

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

... and mighty pattern matching:
```elixir
def fib(0) do: 0
def fib(1) do: 1
def fib(n) when is_integer(n) and n > 1, do: fib(n-1) + fib(n-2)
```

#HSLIDE

Използвайте почти винаги pattern matching, а където не е удобно, може еквивалентния `case`.

#HSLIDE

##Exceptions

#HSLIDE

Част от общата концепция на Elixir и Erlang е грешките да бъдат фатални и да убиват процеса, в който са възникнали. Нека някой друг процес (supervisor) се оправя с проблема.

Например - ако работим с файлове, задачата на една нишка е просто да го отвори и прочете - какво се случва, ако файлът липсва (а не трябва), е проблем на някоя друга нишка.

#HSLIDE

В Elixir грешките (*изключенията*) са `*Error` - `FunctionClauseError`, `MatchError`, `RunTimeError` и около 30 други.

Всеки вид изключение има свое съобщение (стринг), което се достъпва с `.message`
Нека се върнем назад до примерите с `fib(n)`...

#HSLIDE

Изключения се вдигат с `raise` по няколко начина...
```elixir
iex> raise "oops!" # просто съобщение
** (RuntimeError) oops!

iex> raise RuntimeError # изричен тип грешка
** (RuntimeError) runtime error

iex> raise RuntimeError, message: "oops!" # тип + съобщение
** (RuntimeError) oops!
```

#HSLIDE

...но се хващат по един начин с `rescue`.
```elixir
try
  <do_something_dangerous>
rescue
  [FunctionClauseError, RuntimeError] -> IO.puts "normal stuff"
  e in [ArithmeticError] -> IO.puts "Do the math: #{e.message}"
  other ->
    IO.puts "IDK what you did there..."
    raise other, [message: "too late, we're doomed"], System.stacktrace
after # optional
  IO.puts "whew"
end
```

#HSLIDE

На практика `try/rescue` конструкцията също се използва рядко. Алтернативата е - познайте - pattern matching!

Доста от стандартните функции имат два варианта.
```elixir
iex> File.read "no_such.file"
{:error, :enoent}
iex> File.read "existing.file"
{:ok, "file contents, iei"}

iex> File.read! "no_such.file"
** (File.Error) could not read file "no_such.file": no such file or directory

iex> File.read! "existing.file"
"file contents, iei"
```

#HSLIDE

```elixir
def checkFile(str) when is_binary(str) do
  case File.read str do
    {:ok, body}      -> IO.puts "iei" # тук обработваме body
    {:error, reason} -> IO.puts "Oops: #{reason}"
  end
end

def checkFile!(str) when is_binary(str) do
  body = File.read! str # може да хвърли File.Error
  IO.puts "I am #{String.length(body)} bytes long!"
end
```

#HSLIDE

Да дефинираме свое изключение (и да спасим принцесата):
```elixir
defmodule PrincessError do
  # message - задължително, други полета са по избор
  # на практика това е структура!
  defexception message: "save me!", name: "Alex"

  def oops do
    try do
      raise PrincessError
    rescue
      pr in PrincessError ->
        IO.puts "Caught #{pr.name} - she said \"#{pr.message}\""
    end
end

iex> PrincessError.oops
Caught Alex - she said "save me!"
:ok
```

#HSLIDE

Можем и да "хвърляме" всякакви други неща с `throw`:
```elixir
def foo do
  b = 5
  throw b
  IO.puts "this won't print"
end

def bar do
  try do: foo(),
  catch
    :some_atom           -> IO.puts "Caught #{:some_atom}!"
    x when is_integer(x) -> IO.puts "Caught int x = #{x}!"
  end
end

iex> bar
Caught int x = 5!
```

#HSLIDE

Нещо още по-рядко (г/д колкото трикрак еднорог):
```elixir
try do
  exit "I am exiting" # така можем да излезем от процес
catch
  :exit, _ -> IO.puts "not really"
end # и процесът всъщност остава жив
```

#HSLIDE

... но `catch` e лош стил и никога няма да ни се налага (и няма) да го правим.

#HSLIDE

## За целите на този курс се забраняват (освен ако не е необходимо или изрично указано иначе):
* `if, unless, cond`
* `try/catch`
* `try/rescue`

#HSLIDE

## SpecialForms

#HSLIDE

В Elixir има множество "специални форми" - синтактични конструкции, които използваме наготово, но не е ясно как се "оценяват".

Те не са имплементирани на Elixir, следователно не могат да бъдат предефинирани. Винаги се импортират от Kernel. Например:

#HSLIDE

```elixir
% # създава структура (по име и, евентуално, полета)
  defmodule User do
    defstruct name: "John", age: 27
  end
  u = %User{}, v = %User{u | age: 35}

%{} # създава празен Map, реално еквивалентно на Map.new

&(expr) # създава анонимна функция
  &(&1*&1)
  &[&1|&2]
  &{&2,String.length(&1)}
  &(:foo) # трябва да има поне един placeholder (тези &1, &2,...)

{args} # създава наредена n-торка (tuple)
```

#HSLIDE
```elixir
<<args>> # създава bitstring
left :: right # указва опции за bitstring
left . right # създава alias или извиква функция от alias
             # зависи дали right е в кавички или с каква буква започва
left = right # pattern matching
^var # pin оператор - pattern matching без променяне на стойността
alias, case, cond, (fn..end), for, import,
receive, require, try, quote, unquote, with и други...
```

#HSLIDE

Какво не е специална форма, ами макрос, годен за предефиниране:
```elixir
and, or, not, !, &&, ||, .., <>
def, defp, defmacro, defmacrop, defstruct
if, in, is_*, raise, |> и други...
```

#HSLIDE

iei
