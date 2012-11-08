Time::DATE_FORMATS[:time] = "%H.%M"
Time::DATE_FORMATS[:datetime] = "%H.%M"

Timeliness.use_euro_formats
Timeliness.add_formats(:time, 'hh.nn', :before => 'hh:nn:ss')
Timeliness.add_formats(:time, 'hh.n', :after => 'hh:nn:ss')
Timeliness.add_formats(:time, 'h.n', :after => 'hh:nn:ss')
Timeliness.remove_formats(:time, 'h.nn')
Timeliness.add_formats(:time, 'h.nn', :after => 'hh.nn')

Timeliness.add_formats(:datetime, 'yyyy-mm-dd hh.nn', :before => 'yyyy-mm-dd hh:nn:ss')
Timeliness.add_formats(:datetime, 'yyyy-mm-dd h.nn', :before => 'yyyy-mm-dd hh:nn:ss')
Timeliness.add_formats(:datetime, 'yyyy-mm-dd hh.n', :before => 'yyyy-mm-dd hh:nn:ss')
Timeliness.add_formats(:datetime, 'yyyy-mm-dd h.n', :before => 'yyyy-mm-dd hh:nn:ss')

#Timeliness.add_formats(:date, 'yyyy-mm-dd')
Timeliness.add_formats(:date, 'yyyy-mm-d', :before => 'yyyy-mm-dd' )
Timeliness.add_formats(:date, 'yyyy-m-dd', :before => 'yyyy-mm-dd' )
Timeliness.add_formats(:date, 'yyyy-m-d', :before => 'yyyy-mm-dd' )