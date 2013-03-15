defmodule Genomu.Module.Core do
  use Genomu.Module, id: 0, name: :core

  @false_value MsgPack.pack(false)

  @args 0
  def identity(value, _no_arg) do
    value
  end

  @args 1
  @name :identity
  def set_identity(_value, new_value) do
    new_value
  end

  @args 2
  def compose(value, MsgPack.fix_array(len: 2) = arr) do
    {[bin1, bin2], ""} = MsgPack.unpack(arr)
    {op1, ""} = Genomu.Operation.next(bin1)
    {op2, ""} = Genomu.Operation.next(bin2)
    value = Genomu.Operation.apply(op2, value)
    Genomu.Operation.apply(op1, value)
  end

  @args 1
  def assert(value, op) do
    {op, ""} = MsgPack.unpack(op)
    if Genomu.Operation.apply(op, value) == @false_value do
      raise Genomu.Operation.AbortException
    end
    value
  end

end