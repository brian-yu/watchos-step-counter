#include "ICM_20948.h"
ICM_20948_I2C myICM; // IMU Object
const int numItems = 30;    // number of samples to average
const int numItemsFilter = 100;
float accFilterY[numItemsFilter];
float accY[numItems];       // array to store samples
int idx = 0;                // index to store a sample to the array
int idy = 0;
float walkThreshold_pos = 200;
float walkThreshold_neg = 200;
bool walkReset = true;
float stepsWalked = 0;
float yMax = 0;
float yMin = 0;
void setup() {
 Serial.begin(115200);
 Wire.begin();
 Wire.setClock(400000);
 myICM.begin( Wire, 1);
}

void loop() {
 if ( myICM.dataReady() ) {
   myICM.getAGMT();              

   float ay = myICM.accY();

   if (idx < numItems - 1)
     idx ++;
   else
     idx = 0;

   accY[idx] = ay;       // add the sensor reading to the array

   float ySum = 0;
   for (int i = 0; i < numItems; i++)   // calculate the sum
   {
     ySum += accY[i];
   }
   float yAvg = ySum/numItems;   // calculate the average
   if (idy < numItemsFilter - 1)
   {
      idy++;
   }
   else{
    idy=0;
   }
   accFilterY[idy] = yAvg;
   
   yMax = accFilterY[0];
   yMin = accFilterY[0];
   for(int i =0;i < numItemsFilter;i++)
   {
      if(yMax < accFilterY[i])
      {
        yMax = accFilterY[i];
      }
      if(yMin > accFilterY[i])
      {
        yMin = accFilterY[i];
      }
   }
   
   //Serial.print(ax);      // raw acceleration
   //Serial.print(", ");
   if(idy==numItemsFilter-1){
    //Serial.print(yMin);
    //Serial.print(" ");
    //Serial.print(yMax);
    //Serial.print(" ");
    //Serial.print(walkReset);
   if(yMax >= walkThreshold && walkReset)
   {
    stepsWalked++;
    walkReset = false;
   }
   if(yMin <= -walkThreshold && !walkReset)
   {
    stepsWalked++;
    walkReset = true;
   }
   }
   //Serial.print(yMin);
   //Serial.print(" ");
   //Serial.print(yMax);
   //Serial.print(" ");
   Serial.println(stepsWalked);
   //Serial.print(" ");
   //Serial.println(yAvg);
   
   delay(1);
 }
}
