
$fn = 100; // finesse du cylindre

// Paramètres
diametre_ext = 40;
epaisseur = 2;
hauteur = 100;
taille_motif = 5; // taille d'un motif triangulaire

module cut(x0=0,y0=0,x1=1,y1=1,w=0.3)
   hull() {
      translate([x0,y0,0]) 
        circle(r=w);
      translate([x1,y1,0]) 
        circle(r=w);
   }
   
module cell(l=15, a=0.5, t=0.5, theta=13, filled=0) {
  echo("Taille gond", 1/6*sqrt((6*a*l*cos(theta) + 3*l*t + sqrt(3)*(2*(2*sqrt(3)*l*t - sqrt(3)*l)*cos(theta)^2 + 2*l*cos(theta)*sin(theta) - sqrt(3)*l*t))^2 + (6*a*l*sin(theta) + 3*sqrt(3)*l*t + sqrt(3)*(2*(2*sqrt(3)*l*t - sqrt(3)*l)*cos(theta)*sin(theta) + 2*l*sin(theta)^2 - 3*l*t))^2))
//   union() {
//     translate([-1/6*sqrt(3)*(2*(2*sqrt(3)*l*t - sqrt(3)*l)*cos(theta)^2 + 2*l*cos(theta)*sin(theta) - sqrt(3)*l*t),
//  -1/6*sqrt(3)*(2*(2*sqrt(3)*l*t - sqrt(3)*l)*cos(theta)*sin(theta) + 2*l*sin(theta)^2 - 3*l*t)])
//   circle(0.5);  
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

module motif_triangle(x, y, z) {
    translate([x, y, z])
        rotate([0, 0, 0])
            linear_extrude(height = epaisseur + 0.1)
                cell();
}

module cylindre_auxetique() {
    difference() {
        // Cylindre externe
        cylinder(d=diametre_ext, h=hauteur, center=false);

        // Cylindre interne (pour épaisseur)
        translate([0, 0, -0.5])
            cylinder(d=diametre_ext - epaisseur, h=hauteur + 1, center=false);

        // Découpes triangulaires sur la surface cylindrique
        for (z = [0 : taille_motif : hauteur - taille_motif]) {
            for (i = [0 : 360/12 : 360 - 1]) {
                angle = i;
                radius = (diametre_ext + diametre_ext - epaisseur)/4;
                x = radius * cos(angle);
                y = radius * sin(angle);
                rot = angle;
                rotate([0,0,rot])
                    translate([x, y, z])
                        rotate([0, 0, 90])
                            motif_triangle(0, 0, 0);
            }
        }
    }
}

// Génère le cylindre
cylindre_auxetique();