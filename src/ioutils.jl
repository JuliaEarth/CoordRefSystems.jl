# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# helper function to print the actual name of
# the object type inside a deep type hierarchy
prettyname(obj) = prettyname(typeof(obj))
function prettyname(T::Type)
  name = string(T)
  name = replace(name, r"{.*" => "")
  replace(name, r".*\." => "")
end

# remove the "CoordRefSystems" module from type, 
# it is displayed when the module is not imported
function rmmodule(T)
  name = string(T)
  replace(name, "CoordRefSystems." => "")
end

printfields(io, obj; kwargs...) = printfields(io, obj, fieldnames(typeof(obj)); kwargs...)

function printfields(io, obj, fnames; compact=false)
  if compact
    ioctx = IOContext(io, :compact => true)
    vals = map(enumerate(fnames)) do (i, field)
      val = getfield(obj, i)
      str = repr(val, context=ioctx)
      "$field: $str"
    end
    join(io, vals, ", ")
  else
    len = length(fnames)
    for (i, field) in enumerate(fnames)
      div = i == len ? "\n└─ " : "\n├─ "
      val = getfield(obj, i)
      str = repr(val, context=io)
      print(io, "$div$field: $str")
    end
  end
end
