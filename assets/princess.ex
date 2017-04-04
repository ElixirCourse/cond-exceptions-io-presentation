defmodule PrincessError do
  # message - задължително, други полета са по избор
  defexception message: "save me!", name: "Alex"

  def oops do
    try do
      raise PrincessError
    rescue
      e in PrincessError ->
        IO.puts "Caught #{e.name} - she said \"#{e.message}\""
    end
  end
end
