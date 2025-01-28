
for (var i = 0; i < ds_list_size(islands_list); ++i) {
    var isl = islands_list[| i]
    isl.ScanHide()
}
ds_list_destroy(islands_list)
