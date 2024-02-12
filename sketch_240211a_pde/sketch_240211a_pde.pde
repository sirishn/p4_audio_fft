import processing.sound.*;

FFT fft;
AudioIn in;
int bands = (int)Math.pow(2, 14);
float[] spectrum = new float[bands];

//float[] spectrum_window_lin = new float[1920];
float[] spectrum_window_log = new float[1920];

SinOsc sine;


//choose grid
boolean base10_grid = false; //frequency
boolean base2_grid_linear = false;

boolean base2_grid_equal_temperament=true; //12 tet notes
boolean base2_grid_pythagorean_tuning=false;
boolean base2_grid_india_tuning=false;
boolean base2_grid_china_thai_7tet=false;
boolean base2_grid_arab_24tet=false;
boolean base2_grid_india_tuning_22=false;



PFont f;
//textFont(f,36);

void setup() {
  //print("test");
  size(1920,1080);
  background(0);
  stroke(255);
  fill(255);
  stroke(100,150,200);
  //noFill();
    
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
  



  sine = new SinOsc(this);
  //sine.play();
  sine.freq(2000);
  sine.amp(0.7);
  
  f = createFont("Arial",16,true);
}      



void draw() { 
  background(0);
  textFont(f,26);
  stroke(255);
  
  
  //base 10
  if (base10_grid){
  for (int i=0;i<=3;i++){
    
    float x = (float)(16.382*Math.pow(10,i));
    text(x,width*i/3,100);
    line((float)width*i/3,0.0,(float)width*i/3,(float)height);
  }
  
  
  stroke(100);
  for (int i=0;i<3;i++){
    
    //float x = (float)(1.92*Math.pow(10,i));
    //text(x,width*i/3,100);
    float a=16.384;
    double base=a*(Math.pow(10.0, i));
    for (int j=2;j<10;j++){
      float y = j*(float)base;
      float z = (float)Math.log10(y/a);
      float x = (float)z*width/3.0 ;
      line((float)x,0.0,(float)x,(float)height);
      //print("base",base,"x",x,"y",y,"z",z,"\n");
      
      }
    }
  }   

//base 2

  if (base2_grid_linear || base2_grid_equal_temperament || base2_grid_pythagorean_tuning || base2_grid_india_tuning || base2_grid_china_thai_7tet || base2_grid_arab_24tet || base2_grid_india_tuning_22){
  for (int i=0;i<=10;i++){
    
      int x = (int)(16*(float)Math.pow(2,i));
      text(x,width*i/10,100);
      line((float)width*i/10.0,0.0,(float)width*i/10.0,(float)height);
  }
  stroke(100);
  
  for (int i=0;i<=10;i++){
    float a=16.0;
    double base=a*(Math.pow(2.0, i));
    int divisions=12;
    if (base2_grid_china_thai_7tet) {divisions=7;}
    if (base2_grid_arab_24tet) {divisions=24;}
    if (base2_grid_india_tuning_22) {divisions=22;}
    for (int j=1;j<divisions;j++){
      float y =0; //grid line
      if (base2_grid_linear) { y = j*(float)base/12.0+ (float)base; } //linear spaced
      if (base2_grid_equal_temperament) { y = (float)Math.pow(2,j/12.0)* (float)base; }//equal temperament 
      
      //just intonations
      float[] pythagorean_tuning = {0,90,204,294,408,498,588,702,792,906,996,1110};
      float[] india_tuning = {0,112,204,316,386,498,590,702,814,884,1018,1088};
      if (base2_grid_pythagorean_tuning) { y = (float)Math.pow(2,pythagorean_tuning[j]/1200.0)*(float)base; }//pythagorean tuning
      if (base2_grid_india_tuning) { y = (float)Math.pow(2,india_tuning[j]/1200.0)*(float)base; }//india tuning
      if (base2_grid_china_thai_7tet) { y = (float)Math.pow(2,j/7.0)* (float)base;} 
      if (base2_grid_arab_24tet) { y= (float)Math.pow(2,50.0*j/1200)* (float)base;}
      float[] india_tuning_22 = {0,90,112,182,204,294,316,386,408,498,520,590,612,702,792,814,884,906,996,1018,1088,1110};
      if (base2_grid_india_tuning_22) { y = (float)Math.pow(2,india_tuning_22[j]/1200.0)*(float)base; }//india tuning
      
      
      float z = (float)Math.log10(y/a) / (float)Math.log10(2);
      float x = (float)z*width/10.0;
      line((float)x,0.0,(float)x,(float)height);
      //print("base",base,"x",x,"y",y,"z",z,"\n");
      
      }
    }  
  }
  stroke(100,150,200);
  
  fft.analyze(spectrum);

/*
for (int i=0; i<bands; i++){
    spectrum_window_lin[(int)i*width/bands] = spectrum[i] + spectrum_window_lin[(int)i*width/bands];
}
*/
  //spectrum_window_log[0] = 0;
  
 
  spectrum_window_log[0]=spectrum[16];
  for (int i=1; i<width-1; i++){
      float a=16.384;
      long lower = Math.round(a*(Math.pow(10.0, (i)*3.0/width)));
      long upper = Math.round(a*(Math.pow(10.0, (i+1)*3.0/width)));
      //print("lower", lower, "upper", upper);
    for (int j=parseInt(lower); j<parseInt(upper); j++){

      //print(lower);
      //print(upper);
          //print("test");
          //spectrum_window_log[i]+=0.0+spectrum[j]/(upper-lower);
          spectrum_window_log[i]+=spectrum[j];
          //spectrum_window_log[i]=0.001;
          //print("j",j,"lower",lower,"upper",upper,"i",i,spectrum[j],"sum", spectrum_window_log[i], "\n");
          //print("test");
      }
    }

/*
  for (int i=0; i<width; i++){
    line( i, height, i, height - 20*((spectrum_window_lin[i]*height))*5 );
  }
*/

beginShape();
curveVertex(0,height);
for (int i=0; i<width; i++){
  curveVertex(i, height - 20*((spectrum_window_log[i]*height))*2);
}
curveVertex(0,height);
curveVertex(0,height);
endShape();



  //printArray(spectrum_window_log);

  for (int i=0; i<width; i++){
    //spectrum_window_lin[i]=0;
    spectrum_window_log[i]=0;
  }


}
