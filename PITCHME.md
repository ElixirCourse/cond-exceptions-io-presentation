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

Изключения се хвърлят с `raise` по няколко начина...
```elixir
iex> raise "oops!" # просто съобщение
** (RuntimeError) oops!

iex> raise RuntimeError # изричен тип грешка
** (RuntimeError) runtime error

iex> raise RuntimeError, message: "oops!" # тип + съобщение
** (RuntimeError) oops!
```
Всеки вид изключение има свое съобщение (стринг), което се достъпва с `.message`

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
```

#HSLIDE

```elixir
def checkFile(str) when is_binary(str) do
  case File.read str do
    {:ok, body}      -> IO.puts "iei" # тук обработваме съдържанието body като стринг
    {:error, reason} -> IO.puts "Oops: #{reason}"
  end
end

def checkFile!(str) when is_binary(str) do
  body = File.read! str # може да хвърли File.Error
  IO.puts "I am #{String.length(body)} bytes long!" # тук правим каквото искаме
end
```

#HSLIDE

Да дефинираме свое изключение (и да спасим принцесата):
```elixir
defmodule PrincessError
  # message - силно желателно, други полета са по избор
  defexception message: "save me!", name: "Alex"

  def oops do
    try
      raise PrincessError
    rescue
      e in PrincessError -> IO.puts "Caught #{e.name} - she said \"#{e.message}\""
    end
end

iex> PrincessError.oops
Caught Alex - she said "save me!"
:ok
```

#HSLIDE

iei
