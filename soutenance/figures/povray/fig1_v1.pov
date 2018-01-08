#version 3.7;
#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "math.inc"
#include "shapes.inc"   
// several different gold colors, finishes and textures
#include "golds.inc"

// various metal colors, finishes and textures
// brass, copper, chrome, silver
#include "metals.inc"     

#include "accessories.inc" 


//Ambient light  just in case
global_settings { 
	ambient_light 1*White
	assumed_gamma 1.5
	max_trace_level 7

}

//Colour of the far distance
//background { color Gray50 } 
//Camera location and direction
camera {   
  location  <-0,0,40>
  look_at   <0, 0, 0>
  up    <0,1,0>
  right  <1.33,0,0>
  angle 30
  
}       
//Declare light sources
//light_source { <0, 50, -200> White }

//Mathematical form of gaussian beam intensity distribution: 
//---See readme for sources--
//Beam parameters:
#declare lamda = 1.; //wavelength (for propagation properties, not colour)
#declare k = 2*3.14159/lamda; //wavenumber 
#declare I_0 = 1;             //intensity (doesn't work properly, leave as 1) 
                              //-> real intensity is changed with the `emission'...
                              //-> ...declaration in the object definition below
#declare w_0 = 1.;             //beam waist        
#declare phi_0 = pi/2;           //longitudinal phase of beam at origin  

#declare lamda_LG = .2;
#declare w0_LG = .5; 

//--Functions--:   
//Radial coordinate
#declare r_squared = function {
  (pow(x,2)+pow(y,2))
}

#declare zR_LG = pow(w0_LG,2)*3.14159/lamda_LG;
#declare wz_LG = function{
	w0_LG*sqrt(1+pow((z/zR_LG),2))
}
#declare rho = function{
	sqrt(2)*r_squared(x,y,z)/wz_LG(x,y,z)
}
//Laguerre beam LG01
#declare LG_beam = function{
	pow( w0_LG/wz_LG(x,y,z), 2 )*rho(x,y,z)*exp(-pow(rho(x,y,z),2))
}


//Rayleigh range
#declare z_r = 2*pow(w_0,2)*3.14159/lamda;

//Beam diameter as a function of z
#declare w_z = function {
  w_0*sqrt(1+pow((z/z_r),2))
}

//Radius of curvature of the wavefront as a function of z
#declare R_z =  function {
  z*(1+pow(z_r/z, 2))
}

//guoy phase as a function of z
#declare guoy_phase = function {
  atan(z/z_r)
}        

//Basic gaussian beam
#declare gaussian_beam = function { 
  I_0*pow( w_0/w_z(x,y,z), 2 )*exp( -2*r_squared(x,y,z)/pow( w_z(x,y,z), 2 ) ) 
}
                              

//Longitudinal wavefront properties 
#declare wavefronts = function {
  1*sin(k*z)*sin(k*z)
}

//---Object declarations ---
//Transparent cylinder is the `container' for our beam

/*cylinder {
  <0,0,-10>,<0,0,10>,8
  pigment {rgbt 1}   //transparency
  hollow
  interior{ //-- This is where the magic happens, see povray documentation
    media{
      emission <.0,.5,0.>  //intensity/colour of beam, bit buggy, just play with it
      intervals 50       //Number of evaluations of the function.. I think
      density {
		function{ .6*gaussian_beam(x,y,z)*wavefronts(x,y,z) }  //density of emissive media is our function
	//warp{turbulence 0.1} //Add turbulence if you're in the mood ...
      }                   
    } // end of media ---
     media{
      emission <0.2,0.9,3.>  //intensity/colour of beam, bit buggy, just play with it
      intervals 50        //Number of evaluations of the function.. I think
      density {
		function{ 1*LG_beam(x,y,z)*(1+2*exp(-pow(z-10,2)/0.2)+2*exp(-pow(z+10,2)/0.2))}  //density of emissive media is our function
	//warp{turbulence 0.1} //Add turbulence if you're in the mood ...
      }                   
    } // end of media ---
  } // end of interior
//  translate +2*y
  rotate <0,90,0>
}  */       

#declare ion = sphere{
    <0,0,0>, .9              no_shadow
    pigment{rgbt <5,0,0,0.5>}
    hollow
  interior{ //-----------
    media{
      emission <20,5,5>
      //   intervals 1
      //  scattering{1,<1,1,1>}
      density{ spherical
      } // end of density
    } // end of media ---
  } // end of interior
  translate <0,0.00,0>
} //----- end of sphere               


//a circular Rydberg atom
#declare rydberg_ion=union{
  torus {
   1.,//0.8,
   0.15     
  }  
  sphere{ 
  0,0.1      
  }
  pigment{rgbt <5,0,0,0.5>}
    hollow
  interior{ //-----------
    media{
      emission <20,5,5>
      //   intervals 1
      //  scattering{1,<1,1,1>}
      density{ spherical
      } // end of density
    } // end of media ---
  } // end of interior
  no_shadow
} 

           
           
#declare Rydb_scale = 0.5;
#declare delta = 0.5*lamda;
#declare NAtoms = 0;           

//Ion string is just three of them put together
#declare ion_string = union{               
    #for (ii, -NAtoms/2, NAtoms/2)
        object { ion scale Rydb_scale translate <0,ii*delta,0>}
    #end
 /* object { ion scale 0.15 translate <0,0,0> }
  object { ion scale 0.15 translate <0.0,.5*lamda,0> }
  object { ion scale 0.15 translate <0.0,-.5*lamda,0> }
  object { ion scale 0.15 translate <0.0,1*lamda,0> }
  object { ion scale 0.15 translate <0.0,-1*lamda,0> }
    object { ion scale 0.15 translate <0.0,1.5*lamda,0> }
  object { ion scale 0.15 translate <0.0,-1.5*lamda,0> }
    object { ion scale 0.15 translate <0.0,2*lamda,0> }
  object { ion scale 0.15 translate <0.0,-2*lamda,0> }
    object { ion scale 0.15 translate <0.0,2.5*lamda,0> }
    */
   scale 1
}                                       


#declare Rydberg_string = union{         
    #for (ii, -NAtoms/2, NAtoms/2)
        object { rydberg_ion scale Rydb_scale rotate 90*z translate <0,ii*delta,0>}
    #end
  /*
  object { rydberg_ion scale Rydb_scale rotate 90*z translate <0.0,.5*lamda,0>}
  object { rydberg_ion scale Rydb_scale rotate 90*z translate <0.0,-.5*lamda,0>}
  object { rydberg_ion scale Rydb_scale rotate 90*z translate <0.0,1*lamda,0> }
  object { rydberg_ion scale Rydb_scale rotate 90*z translate <0.0,-1*lamda,0> }
    object { rydberg_ion scale Rydb_scale rotate 90*z translate <0.0,1.5*lamda,0> }
  object { rydberg_ion scale Rydb_scale rotate 90*z translate <0.0,-1.5*lamda,0> }
    object { rydberg_ion scale Rydb_scale rotate 90*z translate <0.0,2*lamda,0> }
  object { rydberg_ion scale Rydb_scale rotate 90*z translate <0.0,-2*lamda,0> }
    object { rydberg_ion scale Rydb_scale rotate 90*z translate <0.0,2.5*lamda,0> }
  */
   scale 1
}

#declare Plate =object{
  Round_Box(<-6,-.25, -15>, <6,.25, 15>,0.1,0.1)
  hollow
  texture { T_Gold_1A }
  finish {
   phong 0.9 phong_size 20 
  // specular 0.3
    reflection { 0.1 } 
   
  }
  no_shadow
  }
object{Plate translate 2*y}
object{Plate translate -2*y}  

//Cavity mirrors are constructed in the standard CSG manner
#declare Substrate = merge {
  cylinder {
    <-2,0,0>, <2,0,0>,1
//    pigment { Blue }
  }

  cone {
    <-4,0,0>, 0 //centre and radius one
    <-1.999,0,0>, 1 //centre and radius 2
//    pigment{ Blue }
  }
//  pigment {Blue filter .5}
}


light_source {  

// position
    <7, 40, 10>  1*White 
    spotlight     
    radius 10
    //falloff 50 
    point_at <-10,-10,-10>
// color and intensity as factor
    
// As this light source is only for ambient light, we should suppress
// shadows--otherwise each mirror would have another shadow.
   // shadowless
// We don't want this light source to give scattered light, either.
    media_interaction off 
    fade_distance 50
    fade_power 10
}  
light_source {  

// position
    <10, -10, 40>  1*White 
    spotlight     
    radius 2
    //falloff 50 
    point_at <-10,-5,4>
// color and intensity as factor
    
// As this light source is only for ambient light, we should suppress
// shadows--otherwise each mirror would have another shadow.
   // shadowless
// We don't want this light source to give scattered light, either.
    media_interaction off  
    fade_distance 50
    fade_power 1
}  


//Whack 'em in your picture for fun and profit.
//object { cavity_mirror scale 11 translate 40*x rotate <0,0,0> }
//object { cavity_mirror scale 11 rotate <0,180,0> translate -40*x}  

object { Rydberg_string rotate 90*z rotate -25*x } //rotate -10*x translate 5*y}
//object { ion_string rotate 90*z } //rotate -10*x translate 5*y}

plane { 
// position
    <0, 0, 1>, 
    -100
    pigment {
       White
    } 
    finish{        
    diffuse 0.1
    ambient 0.1
}
           }
           
