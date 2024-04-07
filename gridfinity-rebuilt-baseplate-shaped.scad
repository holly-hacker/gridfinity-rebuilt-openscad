include <gridfinity-rebuilt-utility.scad>
include <standard.scad>

// ===== INFORMATION ===== //
/*
 IMPORTANT: rendering will be better for analyzing the model if fast-csg is enabled. As of writing, this feature is only available in the development builds and not the official release of OpenSCAD, but it makes rendering only take a couple seconds, even for comically large bins. Enable it in Edit > Preferences > Features > fast-csg

https://github.com/kennetek/gridfinity-rebuilt-openscad

*/

// ===== PARAMETERS ===== //

/* [Setup Parameters] */
$fa = 8;
$fs = 0.25;

/* [General Settings] */
// Arbitrary shape
grid_shape = "x.x/xxx/xxx/.x.";

color("tomato")
gridfinityBaseplate(grid_shape);


// ===== CONSTRUCTION ===== //

// Build the full baseplate
module gridfinityBaseplate(grid_shape) {
    width = l_grid-bp_xy_clearance;

    echo("grid_shape", grid_shape);
    split = split_string(grid_shape, "/");
    echo("split", split);

    len_x = len(split);
    len_y = list_max([for (item = split) len(item)]);
    echo("x", len_x, "y", len_y);
    max_x = len_x-1;
    max_y = len_y-1;

    bools = [for (row = [0:max_x]) [for (col = [0:1:max_y]) split[row][col] == "x"]];
    echo(split, bools);

    for (x = [0:max_x]) {
        // row
        translate([x*l_grid, 0, 0])
        {
            for (y = [0:max_y]) {
                // column
                translate([0, y*l_grid, 0])
                {
                    echo("position", x, y);

                    if (bools[x][y])
                    difference() {
                        // rounded_rectangle(width, width, h_base, r_base);
                        rounded_rectangle(l_grid, l_grid, h_base, 0);

                        gridfinityBase(1, 1, l_grid, 1, 1, 0, 0.5, false);
                    }
                }
            }
        }
    }
}

// TODO: turn into generic fold function?
function list_max(list, acc = 0, index = 0) =
    index > len(list)-1
        ? acc
        : index == len(list)-1
            ? max(acc, list[index])
            : list_max(list, max(acc, list[index]), index + 1);

function explode_string(str) =
    [
        for (i = [0:len(str)-1])
        str[i]
    ];

// Split a string once by a separator
function split_string(str, sep) =
    let (indices = search(sep, str, num_returns_per_match = 0)[0])
    [
        for (i = [0:len(indices)])
        let (start_idx = defined_or(indices[i-1], -1)+1, end_idx = defined_or(indices[i], len(str)))
        substring(str, start_idx, end_idx - start_idx)
    ];

// Slice a substring from a string
function substring(input, start_index, length) =
    length > 0
        ? str(input[start_index], substring(input, start_index + 1, length - 1))
        : "";

// Returns the first value if it is defined, or the second value otherwise
function defined_or(input, or) = is_undef(input) ? or : input;
