cell_size=15;
a=0.64;
t=0.9;
theta=13;
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

  difference() {
    // polygon([[0,0], [l,0], [l/2,sqrt(3/4)*l]]);
    for( i = [0:2]) {
      translate([l/2,l/3*sqrt(3/4), 0])
      rotate([0, 0, 120*i])
      translate([-l/2,-l/3*sqrt(3/4), 0])
      translate([t/sqrt(5), 2*t/sqrt(5)])
        rotate([0, 0, theta])
          cut(0,0,l*a,0);
    };  
  }
};

module doublecell(l=15, a=0.5, t=0.5, theta=13) {
  cell(l,a,t,theta);
  mirror([0,1,0]) 
  cell(l,a,t,theta);
}

module multicell(l=15, a=0.5, t=0.5, theta=13, u = 1, v= 1) {
  difference() {
    translate([l,l])
    minkowski() {
      circle(l);
      square([l*(u-0.6),l*(v-2)]);
    };
    for ( i = [0:u]) {
      for ( j = [0:v]) {
        translate([i*l+j%2/2*l,j*l*sqrt(3/4),0.2*(i+j)])
          doublecell(l,a,t,theta);

      }
    };
  }
}

// difference() {
//   // square(10);
//   cell(10, t=1);
// }

module extruded_multicell(l=15, a=0.5, t=0.5, theta=13, u = 1, v= 1, height=4) {
  difference() {
    render()
    linear_extrude(height=height) {
      multicell(l,a,t,theta,u,v);
    };
    translate([5,10,height-0.4])
    rotate([0,0,90])
    // scale(0.2)
    linear_extrude(height=0.5) {
    text(str("θ",theta), 3.5, $fn=16);
    };
    translate([5,10+l*1.5,height-0.4])
    rotate([0,0,90])
    // scale(0.2)
    linear_extrude(height=0.5) {
    text(str("A",a), 3.5, $fn=16);
    };
    translate([(l*(v+1)-10),12+l*0.5,height-0.4])
    rotate([0,0,90])
    // scale(0.2)
    linear_extrude(height=0.5) {
    text(str("T",t), 3.5, $fn=16);
    };
  }
}

extruded_multicell(cell_size, u=num_lines, v=num_cols, a=a, t=t, theta=theta, height=height);

