include <config.scad>
use <GDMUtils.scad>
use <NEMA.scad>
use <joiners.scad>


$fa = 1;
$fs = 1.5;


jhead_length = 40; // mm
jhead_block_size = [18.7, 16, 9.6];
jhead_block_off = 7; //mm


module jhead_hotend()
{
	block_h = jhead_block_size[2];
	down(jhead_length/2-jhead_groove_thick-jhead_shelf_thick) {
		color([0.3, 0.3, 0.3])
		difference() {
			cylinder(h=jhead_length, d=jhead_barrel_diam, center=true);
			cylinder(h=jhead_length+1, d=2, center=true, $fn=12);
			up(4*4/2-jhead_length/2+0.5*25.4) {
				zring(n=4, r=jhead_barrel_diam/2) {
					zspread(4, n=4) {
						hull() {
							yspread(6) {
								yrot(90) cylinder(h=4*2, d=3, center=true, $fn=12);
							}
						}
					}
				}
			}
			up(jhead_length/2-jhead_shelf_thick-jhead_groove_thick/2) {
				difference() {
					cylinder(h=jhead_groove_thick, d=jhead_barrel_diam+1, center=true);
					cylinder(h=jhead_groove_thick+1, d=jhead_groove_diam, center=true);
				}
			}
		}
		color("silver")
		down((jhead_length+block_h)/2) {
			difference() {
				left(jhead_block_off/2) {
					cube(jhead_block_size, center=true);
				}
				left(jhead_block_off) {
					xrot(90) cylinder(h=100, d=6, center=true);
				}
				cylinder(h=100, d=2, center=true, $fn=12);
			}
			difference() {
				down((block_h+3)/2) {
					cylinder(h=3, r=4, center=true);
					down((3+1.2)/2) {
						cylinder(h=1.2, r1=1, r2=4, center=true);
					}
				}
				cylinder(h=50, d=0.4, center=true, $fn=8);
			}
		}
	}
	color("silver")
	up(jhead_groove_thick+jhead_shelf_thick) {
		difference() {
			cylinder(h=jhead_cap_height, d=jhead_cap_diam, $fn=6);
			down(0.5) cylinder(h=jhead_cap_height+1, d=2, $fn=12);
		}
	}
}


module extruder_drive_gear()
{
	color("silver") {
		difference() {
			cylinder(h=12, d=extruder_drive_diam);
			up(12-3.5) {
				torus(ir=extruder_drive_diam/2-1, or=extruder_drive_diam/2+4, $fn=24);
			}
		}
	}
}


module jhead_platform()
{
	platform_vert_off = rail_height+groove_height+rail_offset;
	l = extruder_length;
	w = rail_width;
	h = rail_height;
	thick = jhead_groove_thick;
	motor_width = nema_motor_width(17);

	color("SteelBlue")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Bottom.
				up(thick/2)
					cube(size=[w, l, thick], center=true);

				// Walls.
				xspread(rail_spacing+joiner_width) {
					up(h/6) {
						cube(size=[joiner_width, l/2-5, h/3], center=true);
					}
				}

				// Rubber band clip
				right((rail_spacing)/2) {
					up(h/3-0.05) {
						right_half(30) {
							trapezoid([joiner_width, 8], [joiner_width+5, 8], h=5);
						}
					}
				}

				// Wall Triangles
				zring(n=2) {
					xflip_copy() {
						up(h/2) {
							fwd(l/2-l/6-10+0.05) {
								right((rail_spacing+joiner_width)/2) {
									thinning_brace(h=h, l=l/3, thick=joiner_width, strut=5);
								}
							}
						}
					}
				}

				// Side support walls
				yspread(l-2*10+4) {
					up(h/5/2) {
						difference() {
							cube([w, 4, h/5], center=true);
						}
					}
				}

				// Jhead base
				fwd(extruder_shaft_len/4/2) {
					up((jhead_shelf_thick+jhead_groove_thick)/2) {
						cube([rail_width, extruder_shaft_len*0.75, jhead_shelf_thick+jhead_groove_thick], center=true);
					}
					up(jhead_shelf_thick+jhead_groove_thick) {
						up(motor_width*0.37/2) {
							cube([jhead_barrel_diam+8, extruder_shaft_len*0.75, motor_width*0.37], center=true);
						}
					}
				}

				// Lower idler clip
				up(jhead_groove_thick+jhead_shelf_thick) {
					left((jhead_barrel_diam+8)/2+8) {
						up(5/2) {
							left_half() {
								difference() {
									trapezoid([20, extruder_shaft_len/2], [10, extruder_shaft_len/2], h=5, center=true);
									down(5-3) {
										cube([2*2, extruder_shaft_len/2-4, 5], center=true);
									}
								}
							}
						}
					}
				}

				// Motor face plate.
				fwd(extruder_shaft_len/2-2/2) {
					right(extruder_drive_diam/2-0.5) {
						up(thick+jhead_shelf_thick+motor_width/2/2) {
							cube([motor_width, 2, motor_width/2], center=true);
						}
					}
				}


				// Motor supports
				fwd(motor_length/2+extruder_shaft_len/2) {
					right(extruder_drive_diam/2-0.5) {
						up(20/2) {
							xspread(motor_width-5) {
								yspread(rail_height-15) {
									cube([20, 15, 20], center=true);
								}
							}
						}
					}
				}
			}

			// Clear motor and extruder parts
			up(jhead_groove_thick+jhead_shelf_thick) {
				up(motor_width/2) {
					left(0.5) {
						right(extruder_drive_diam/2) {
							hull() {
								grid_of(za=[0, 20]) {
									xrot(90) cylinder(h=extruder_shaft_len+1, d=extruder_drive_diam+1, center=true);
								}
							}
							fwd(extruder_shaft_len/2) {
								xrot(90) nema17_mount_holes(depth=2*2+0.05, l=0);
								fwd(motor_length/2) {
									cube([motor_width, motor_length, motor_width], center=true);
								}
							}
						}
						left(extruder_idler_diam/2) {
							back(1) {
								hull() {
									grid_of(xa=[0,-10]) {
										xrot(90) cylinder(h=extruder_shaft_len-2+0.05, d=extruder_idler_diam+2, center=true);
									}
								}
							}
						}
					}
				}
				up(jhead_cap_height+2*printer_slop) {
					cube([jhead_barrel_diam, filament_diam+4*printer_slop, 0.6], center=true);
					up(0.3) {
						cube([filament_diam+4*printer_slop, filament_diam+4*printer_slop, 0.6], center=true);
					}
				}
			}

			// Motor cooling convection hole.
			fwd(motor_width/2+extruder_shaft_len/2) {
				right(extruder_drive_diam/2-0.5) {
					cylinder(d=motor_width*0.85, h=thick*10, center=true);
				}
			}

			// Filament feed
			cylinder(d=filament_diam+4*printer_slop, h=100, center=true, $fn=12);
			up(jhead_groove_thick+jhead_shelf_thick+motor_width*0.37-1+0.05) {
				cylinder(d1=filament_diam+4*printer_slop, d2=filament_diam*3, h=2, center=true, $fn=12);
			}

			// Jhead groove slot
			hull() {
				grid_of(ya=[0,extruder_length/4]) {
					up(jhead_groove_thick/2) {
						cylinder(h=jhead_groove_thick+0.1, d=jhead_groove_diam+printer_slop, center=true);
					}
				}
			}

			// Jhead shelf slot
			up(jhead_groove_thick) {
				hull() {
					grid_of(ya=[0,extruder_length/4]) {
						up((jhead_shelf_thick+jhead_cap_height+2*printer_slop)/2)
							cylinder(h=jhead_shelf_thick+jhead_cap_height+2*printer_slop+0.1, d=jhead_barrel_diam+printer_slop, center=true);
					}
				}
			}

			up((jhead_shelf_thick+jhead_groove_thick)/2) {
				// Extruder fan hole.
				back(extruder_length/4) {
					cylinder(h=jhead_shelf_thick+jhead_groove_thick+1, d=extruder_fan_size+2*printer_slop+2*2, center=true);
				}

				// Wire access slot
				back(extruder_length/7) {
					hull() {
						xspread(w*0.5) {
							cylinder(h=jhead_shelf_thick+jhead_groove_thick+1, d=8, center=true);
						}
					}
				}
			}

			// Clear space for joiners.
			up(rail_height/2+0.005) {
				joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=l+0.001, h=h, w=joiner_width, clearance=5, a=joiner_angle);
			}
		}

		// Rail end  joiners.
		up(rail_height/2) {
			joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=l-0.05, h=h, w=joiner_width, l=10, a=joiner_angle);
		}

		// Motor joiner clips
		right(extruder_drive_diam/2-0.5) {
			fwd(extruder_shaft_len/2+motor_length/2) {
				difference() {
					up(jhead_groove_thick+jhead_shelf_thick+motor_width/2) {
						xrot(90) joiner_pair(spacing=motor_mount_spacing, h=rail_height, w=joiner_width, l=motor_width/2+jhead_shelf_thick, a=joiner_angle);
					}
					cube([motor_mount_spacing+joiner_width+1, rail_height/3, motor_width*0.75], center=true);
				}
			}
		}

		// Fan Shroud Joiners
		up(thick+jhead_shelf_thick+extruder_fan_thick-6) {
			back(extruder_length/4) {
				xspread(extruder_fan_size+2*joiner_width) {
					xrot(90) half_joiner2(h=extruder_fan_size/2, w=joiner_width, a=joiner_angle);
				}
			}
		}
	}
}



module jhead_platform_parts() { // make me
	jhead_platform();
}



jhead_platform_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap