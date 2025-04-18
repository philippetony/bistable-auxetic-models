$fa = 0.02;
$fs = 0.02;

height = 0.2; 

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
    translate([12,5])
    minkowski() {
      circle(10);
      square([10*(u-1),10*(v-2)]);
    };
    for ( i = [0:u]) {
      for ( j = [0:v]) {
        translate([i*l+j%2/2*l,j*l*sqrt(3/4),0.2*(i+j)])
          doublecell(l,a,t,theta);

      }
    };
  }
}


linear_extrude(height=4) {
  multicell(10, u=8, v=8, a=0.58, t=0.7, theta=15);
}
