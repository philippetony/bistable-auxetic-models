cell_size=26;
a=0.697;
t=0.05;
theta=13;
height=2;

/* [Hidden] */
num_lines=2;
num_cols=3;
$fa = 0.02;
$fs = 0.02;

module cut(x0=0,y0=0,x1=1,y1=1,w=0.3)
   hull() {
      translate([x0,y0,0]) 
        circle(r=w);
      translate([x1,y1,0]) 
        circle(r=w);
   }
   
module cell(l=15, a=0.5, t=0.5, theta=13, filled=0) {
  echo("Taille gond", 1/6*sqrt((6*a*l*cos(theta) + 3*l*t + sqrt(3)*(2*(2*sqrt(3)*l*t - sqrt(3)*l)*cos(theta)^2 + 2*l*cos(theta)*sin(theta) - sqrt(3)*l*t))^2 + (6*a*l*sin(theta) + 3*sqrt(3)*l*t + sqrt(3)*(2*(2*sqrt(3)*l*t - sqrt(3)*l)*cos(theta)*sin(theta) + 2*l*sin(theta)^2 - 3*l*t))^2))
  difference() {
    if(filled) {
     polygon([[0,0], [l,0], [l/2,sqrt(3/4)*l]]);
    };
    for( i = [0:2]) {
      translate([l/2,l/3*sqrt(3/4), 0])
      rotate([0, 0, 120*i])
      translate([-l/2,-l/3*sqrt(3/4), 0])
      translate([1/2*t*l, sqrt(3)/2*t*l])
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
}

module multicell(l=15, a=0.5, t=0.5, theta=13, u = 1, v= 1) {
  union() {

  difference() {
    translate([l,l])
    union()
    {
      minkowski() {
        circle(l);
        square([l*(u-0.6),l*(v-2)]);
      };
      translate([0, 0, 0]) {
        
      };
      // translate([-15,-2,0])
      // circle(10);
    };
    for ( i = [0:u+1]) {
      for ( j = [0:v]) {
        translate([i*l+j%2/2*l,j*l*sqrt(3/4),0.2*(i+j)])
          doublecell(l,a,t,theta);

      }
    };
  };
    translate([-8,22,0])
    circle(10);
  }
}

// difference() {
//   l=cell_size;
//   polygon([[0,0], [l,0], [l/2,sqrt(3/4)*l]]);
//   // square());
//   cell(cell_size, t=t, a=a, theta=theta);
// }

module extruded_multicell(l=15, a=0.5, t=0.1, theta=13, u = 1, v= 1, height=4) {
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
      linear_extrude(height=0.5) {
      text(str("g", round(100 * (1/6*sqrt((6*a*l*cos(theta) + 3*l*t + sqrt(3)*(2*(2*sqrt(3)*l*t - sqrt(3)*l)*cos(theta)^2 + 2*l*cos(theta)*sin(theta) - sqrt(3)*l*t))^2 + (6*a*l*sin(theta) + 3*sqrt(3)*l*t + sqrt(3)*(2*(2*sqrt(3)*l*t - sqrt(3)*l)*cos(theta)*sin(theta) + 2*l*sin(theta)^2 - 3*l*t))^2)))/100), 3, $fn=16);
      };
    };
  }
}

// rotate([0,0,-90])
// extruded_multicell(cell_size, u=num_lines, v=num_cols, a=a, t=t, theta=theta, height=height);

module hexagon_dome(l=15, t=0.1, c=5) {
  cell_height = l*sqrt(3/4);
  for (z = [0:2])
  rotate([0,0,120*z])
  for (m=[0:1])
  mirror([0,m,0])
  translate([l/2,cell_height/2])
  for ( u = [0:c]) {
  for ( v = [0:u]) {
      theta = (u+v)*12/c+1;
      computed_a = -1/30*(10*sqrt(3)*l*cos(theta)^2*sin(theta) + 10*sqrt(3)*l*sin(theta)^3 + 30*(2*l*t - l)*cos(theta)^3 + 30*(2*l*t - l)*cos(theta)*sin(theta)^2 + 39*sqrt(cos(theta)^2 + sin(theta)^2))/(l*cos(theta)^2 + l*sin(theta)^2);
      if (u+v<c) {
      translate([l*u/2,cell_height*v])
      mirror([0,(u+v)%2,0])
      translate([-l/2,-cell_height/2])
      cell(l=l,a=computed_a,t=t,theta=theta, filled=1);
        // text(str("U",u,",V",v), 3, $fn=16);
      }
  }
  };
};

// linear_extrude(height=height) 
// hexagon_dome(l=26,c=5);

module hexagon_bra(l=15, t=0.1, c=5) {
  cell_height = l*sqrt(3/4);

  
  for (z = [0:2])
  rotate([0,0,120*z])
  for (m=[0:1])
  mirror([0,m,0])
  translate([l/2,cell_height/2])
  for ( u = [0:c]) {
  for ( v = [0:u]) {
      theta = (u+v)*12/c+1;
      computed_a = -1/30*(10*sqrt(3)*l*cos(theta)^2*sin(theta) + 10*sqrt(3)*l*sin(theta)^3 + 30*(2*l*t - l)*cos(theta)^3 + 30*(2*l*t - l)*cos(theta)*sin(theta)^2 + 39*sqrt(cos(theta)^2 + sin(theta)^2))/(l*cos(theta)^2 + l*sin(theta)^2);
      if (u+v<c) {
      translate([l*u/2,cell_height*v])
      mirror([0,(u+v)%2,0])
      translate([-l/2,-cell_height/2])
      cell(l=l,a=computed_a,t=t,theta=theta, filled=1);
        // text(str("U",u,",V",v), 3, $fn=16);
      }
  }
  };
  translate([(c+1)*l, 0, 0]) {
    for (z = [0:2])
    rotate([0,0,120*z])
    for (m=[0:1])
    mirror([0,m,0])
    translate([l/2,cell_height/2])
    for ( u = [0:c]) {
    for ( v = [0:u]) {
        theta = (u+v)*12/c+1;
        computed_a = -1/30*(10*sqrt(3)*l*cos(theta)^2*sin(theta) + 10*sqrt(3)*l*sin(theta)^3 + 30*(2*l*t - l)*cos(theta)^3 + 30*(2*l*t - l)*cos(theta)*sin(theta)^2 + 39*sqrt(cos(theta)^2 + sin(theta)^2))/(l*cos(theta)^2 + l*sin(theta)^2);
        if (u+v<c) {
        translate([l*u/2,cell_height*v])
        mirror([0,(u+v)%2,0])
        translate([-l/2,-cell_height/2])
        cell(l=l,a=computed_a,t=t,theta=theta, filled=1);
          // text(str("U",u,",V",v), 3, $fn=16);
        }
    }
    };
  }
  e=c-2;
  for (j = [0:1])
  mirror([0,j,0])
  translate([ceil(c/2)*l,((c-1)/2)*cell_height])
  translate([-ceil(e/2)/2*l,0])
  mirror([0,1,0])
  translate([l/2,cell_height/2])
  for ( u = [0:c]) {
  for ( v = [0:u]) {
      theta = 12;
      computed_a = -1/30*(10*sqrt(3)*l*cos(theta)^2*sin(theta) + 10*sqrt(3)*l*sin(theta)^3 + 30*(2*l*t - l)*cos(theta)^3 + 30*(2*l*t - l)*cos(theta)*sin(theta)^2 + 39*sqrt(cos(theta)^2 + sin(theta)^2))/(l*cos(theta)^2 + l*sin(theta)^2);
      if (u+v<e) {
      translate([l*u/2,cell_height*v])
      mirror([0,(u+v)%2,0])
      translate([-l/2,-cell_height/2])
      cell(l=l,a=computed_a,t=t,theta=theta, filled=1);
        // text(str("U",u,",V",v), 3, $fn=16);
      }
  }
  };
};

// linear_extrude(height=height) 
// hexagon_bra(l=26,c=7);

module cylinder_bracelet(l=15, a=0.60, t=0.1, theta=13, r=32, full_height=1.9) {
  cell_height = l*sqrt(3/4);
  perimeter = 2*PI*r;
  num_cells = round(perimeter / l)*2/0.89;
  // cylinder(h=2*cell_height-4,r=r+2, center=true);
  // cylinder(h=2*cell_height-3,r=r, center=true);
  difference() {
  cylinder(h=full_height*cell_height-4,r=r+2, center=true);
  cylinder(h=full_height*cell_height-3,r=r, center=true);
  union() {
  // for (k=[0:1])
  // // translate([0, 0, -cell_height/2])
  // mirror([0,0,k])
  // for (j=[0:1])v
  // translate([0, 0, -cell_height*0.4])
  // mirror([0,0,j])
  // translate([0,0,cell_height*j])
  // for (k=[0:1])
  // mirror([0,0,k])
  // translate([0,0,2*cell_height*0.44])
  for (j=[0:1])
  mirror([0,0,j])
  translate([0,0,cell_height*0.44])
  for (x = [0:num_cells]) {
    rotate([0,0,360/num_cells*x])
    translate([0,r+10,0])
    // multmatrix(m=[
    //   [1,0,0],
    //   [0,1,0], 
    //   [0,0,1]
    //   ])
    rotate([90,0,0])
    linear_extrude(height=20, twist=0, scale=0.74, convexity=3)
    mirror([0,x%2,0])
    translate([-l/2,-cell_height/2])
    cell(l=l, a=a, t=t, theta=theta);
  }
  }
  }
};

cylinder_bracelet(l=26);