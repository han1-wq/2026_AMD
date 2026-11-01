set work [file normalize [file dirname [info script]]]
set reports [file join $work candidate_routed]
set_param general.maxThreads 2
open_checkpoint [file join $reports platform_candidate.dcp]
report_bus_skew -warn_on_violation -file [file join $reports bus_skew.rpt]
report_methodology -file [file join $reports methodology.rpt]
close_design
exit