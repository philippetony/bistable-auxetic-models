cell_size=15;
a=0.725;
t=0.1;
theta=20;
height=2;

/* [Hidden] */
num_lines=3;
num_cols=4;
$fa = 0.02;
$fs = 0.02;

module cut(x0=0,y0=0,x1=1,y1=1,w=0.3)
   hull() {
      translate([x0,y0,0]) 
        circle(r=w);
      translate([x1,y1,0]) 
        circle(r=w);
   }
   
module cell(l=15, a=0.5, t=0.5, theta=13) {
  echo("Taille gond", sqrt((l*t*cos(theta)^2 - a*l*sin(theta) - (l*t - l)*cos(theta)*sin(theta) - l*t)^2 + (l*t*cos(theta)*sin(theta) + a*l*cos(theta) + (l*t - l)*cos(theta)^2)^2))
  difference() {
    // polygon([[0,0], [l,0], [l/2,sqrt(3/4)*l]]);
    for( i = [0:3]) {
      translate([l/2,l/2, 0])
      rotate([0, 0, 90*i])
      translate([-l/2,-l/2, 0])
      translate([0, t*l])
        rotate([0, 0, theta])
          cut(0,0,l*a,0);
    };  
  }
  // };
  
};

module doublecell(l=15, a=0.5, t=0.5, theta=13) {
  cell(l,a,t,theta);
  mirror([0,1,0]) 
  cell(l,a,t,theta);

  mirror([1,0,0]) 
  union() {
  cell(l,a,t,theta);
  mirror([0,1,0]) 
  cell(l,a,t,theta);
  };
}

module multicell(l=15, a=0.5, t=0.5, theta=13, u = 1, v= 1) {
  union()
  {
    difference() {
        translate([l,l])
        union()
        {
        minkowski() {
            circle(l);
            square([l*(u-0.4),l*(v-2)]);
        };
        translate([0, 0, 0]) {
            
        };
        };
        for ( i = [0:u+1]) {
        for ( j = [0:v]) {
            translate([i*l*2,j*l*2,0])
            doublecell(l,a,t,theta);
        }
        };
  }
    translate([-8,22,0])
    circle(10);
  }
}

// difference() {
//   l=cell_size;
//   square(l);
//   // square());
//   cell(cell_size, t=t, a=a, theta=theta);
// }

module extruded_multicell(l=15, a=0.5, t=0.5, theta=13, u = 1, v= 1, height=4) {
  difference() {
    render()
    linear_extrude(height=height) {
      multicell(l,a,t,theta,u,v);
    };
    translate([-7,8,0])
    union(){
        translate([-6,9,height-0.4])
        rotate([0,0,90])
        // scale(0.2)
        linear_extrude(height=0.5) {
        text(str("θ",theta), 3, $fn=16);
        };
        translate([-2,8,height-0.4])
        rotate([0,0,90])
        // scale(0.2)
        linear_extrude(height=0.5) {
        text(str("A",a), 3, $fn=16);
        };
        translate([1.5,8,height-0.4])
        rotate([0,0,90])
        // scale(0.2)
        linear_extrude(height=0.5) {
        text(str("t ",t), 3, $fn=16);
        };
        translate([5,8,height-0.4])
        rotate([0,0,90])
        // scale(0.2)
        linear_extrude(height=0.5) {
        text(str("g", round(100 * sqrt((l*t*cos(theta)^2 - a*l*sin(theta) - (l*t - l)*cos(theta)*sin(theta) - l*t)^2 + (l*t*cos(theta)*sin(theta) + a*l*cos(theta) + (l*t - l)*cos(theta)^2)^2))/100), 3, $fn=16);
        };
    }
  }
}

rotate([0,0,-90])
extruded_multicell(cell_size, u=num_lines, v=num_cols, a=a, t=t, theta=theta, height=height);

