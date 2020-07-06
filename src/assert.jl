function always_assert(cond::Bool,
                       msg::String = "")
    if !cond
        throw(AlwaysAssertionError(msg))
    end
    return nothing
end
