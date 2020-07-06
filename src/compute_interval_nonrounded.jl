import Dates

function _compute_interval_nonrounded(start_datetime, current_datetime)
    if start_datetime > current_datetime
        throw(ArgumentError("Start datetime must be less than or equal to current datetime"))
    end
    return current_datetime - start_datetime
end
