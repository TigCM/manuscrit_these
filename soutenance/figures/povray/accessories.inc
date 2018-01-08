//definition of various accessories for standard experient scheme
///////////////////////////////////////////////////////////////////////////////////
/// contents
//beam(start,stop,rad,col)
//defines a beam sarting and ending at given points. Pigmented by col
//rydberg
//a circular Rydberg atom
//channeltron
//a channeltron electron multiplier center of input in 00
//flatdetector
//a detector with a flat condenser. Center of condenser in 000
//roofdetector
//a detector with a roof condenser. Center of condenser in 000
////////////////////////////////////////////////////////////////////////////////////

//defines a beam sarting and ending at given points. Pigmented by col
#macro beam(start,stop,rad,col)
union{
  cylinder{
    start,  stop,  rad
  }  
  cone{ 
   stop,rad*3,(stop+(stop-start)/10.0),0
  } 
  pigment{col}
}
#end

   
//a circular Rydberg atom
#declare rydberg=union{
  torus {
   0.8,
   0.1
  }  
  sphere{ 
  0,0.1
  }
  pigment{Blue}  
  finish{ambient 0.5 }
  no_reflection
}   

//a circular Rydberg atom
#declare rydbergmagenta=union{
  torus {
   0.8,
   0.1
  }  
  sphere{ 
  0,0.1
  }
  pigment{Magenta}  
  finish{ambient 0.5 }
    no_reflection
}   

//a circular Rydberg atom
#declare rydbergred=union{
  torus {
   0.8,
   0.1
  }  
  sphere{ 
  0,0.1
  }
  pigment{Red}  
  finish{ambient 0.5 }
    no_reflection
}   



//a channeltron electron multiplier center of input in 00

#declare channeltron=difference{
  union{
    cone{
      0,0.65
      <0,-1,0>,0.15
    }
    cylinder{
      -1*y, -3*y, 0.15
    }
  }
  union{
    cone{
      0.0001,0.6
      <0,-1.001,0>,0.1
    }
    cylinder{
      -0.99999*y,-3.0001*y,0.1
    }
  }
  pigment{                
     color rgbf <0.4, 0.5, 0.6, 0.5>
  }
  finish{
    specular 0.8
    roughness 0.01
    ambient 0.3
    diffuse 0.2
    reflection {
      0.0, 1.0
      fresnel on
    }
    conserve_energy  }
}

// a roof detection condenser lower hole centered on 00
#declare roofcondenser=union{
  difference{
    box{
      <-1,0,-1>
      <1,0.05,1>
    }
    cylinder{
      <0,-0.001,0>
      <0,0.050001,0>
      0.2
    }
  }//difference
  box{
    <-1,0,-1>
    <1,0.05,1> 
    rotate -10*z
    translate 1*y
  }
  texture{
    T_Copper_2A
  }
}//union


// a flat detection condenser lower hole centered on 00
#declare flatcondenser=union{
  difference{
    box{
      <-1,0,-1>
      <1,0.05,1>
    }
    cylinder{
      <0,-0.001,0>
      <0,0.050001,0>
      0.2
    }
  }//difference
  box{
    <-1,0,-1>
    <1,0.05,1> 
    translate 1*y
  }
  texture{
    T_Copper_2A
  }
}//union

//a detector with a flat condenser. Center of condenser in 000
#declare flatdetector=union{
  object{
    flatcondenser
    translate -0.5*y
  }
  object{
    channeltron
    translate -1.2*y
  }
}

//a detector with a roof condenser. Center of condenser in 000
#declare roofdetector=union{
  object{
    roofcondenser
    translate -0.5*y
  }
  object{
    channeltron
    translate -1.2*y
  }
}

//an oven with center of the exit hole in 000
#declare oven=difference{
  cylinder{
    <0,-1,0>
    <0,1,0>
    1
  }
  cylinder{
    <0,-0.8,0>
    <0,0.8,0>
    0.8
  }
  cylinder{
    <0.7,0,0>
    <1.1,0,0>
    0.2
  }
  translate <-1,0,0>
  texture{
     T_Chrome_2A
  }
}

//a circularization box centered in 000
#declare circbox=difference{
  box{
    <-1,-1,-1>
    <1,1,1>
  }
  box{
    <-0.8,-0.8,-0.8>
    <0.8,0.8,0.8>
  }
  cylinder{
    <-1.1,0,0>
    <1.1,0,0>
    0.2
  }
  cylinder{
    <0,0,-1.1>
    <0,0,1.1>
    0.3
  }
  texture{
     T_Chrome_2A
  }
}

//a microwave source
#declare source=superellipsoid {
  <0.2,  // east-west exponent (0.0 ... 1.0)
  0.2>   // north-south exponent (0.0 ... 1.0)  
  texture{T_Silver_3B} 
  scale 1
}


