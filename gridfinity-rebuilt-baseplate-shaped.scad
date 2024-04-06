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
grid_shape = "x..x/xxxx";

color("tomato")
gridfinityBaseplate(grid_shape);


// ===== CONSTRUCTION ===== //

// Build the full baseplate
module gridfinityBaseplate(grid_shape) {
    width = l_grid-bp_xy_clearance;

    echo("grid_shape", grid_shape);
    split = split_string(grid_shape, "/");
    echo("split", split);

    for (x = [0:len(split)-1]) {
        // row
        translate([x*l_grid, 0, 0])
        {
            exploded = explode_string(split[x]);
            echo("exploded", exploded);
            for (y = [0:len(exploded)-1]) {
                // column
                echo(x, y);
                translate([0, y*l_grid, 0])
                {
                    if (exploded[y] == "x")
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

echo("split test: ", split_string("hello,world,yay", ","));
