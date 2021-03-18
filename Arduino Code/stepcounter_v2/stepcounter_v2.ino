#include "ICM_20948.h"
ICM_20948_I2C myICM; // IMU Object
const int numItems = 30;    // number of samples to average
float accY[numItems];       // array to store samples
int idx = 0;                // index to store a sample to the array

const int numItems_baseline = 300;    // number of samples to average
float accY_baseline[numItems_baseline];       // array to store samples
int idb = 0;                // index to store a sample to the array

float walkThreshold_pos = 100;
float walkThreshold_neg = -100;
float runThreshold_pos = 300;
float runThreshold_neg = -300;
bool walkReset = true;
float stepsWalked = 0;
float stepsRan = 0;
float yAvg = 0;
float yAvg_prev1 = 0;
float yAvg_prev2 = 0;
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

   if (idb < numItems_baseline - 1)
     idb ++;
   else
     idb = 0;

   accY_baseline[idb] = ay;       // add the sensor reading to the array

   float ySum_baseline = 0;
   for (int i = 0; i < numItems_baseline; i++)   // calculate the sum
   {
     ySum_baseline += accY_baseline[i];
   }
   //float yBase = ySum_baseline/numItems_baseline;
   yAvg_prev2 = yAvg_prev1;
   yAvg_prev1 = yAvg;
   yAvg = (ySum/numItems)-(ySum_baseline/numItems_baseline);
   //float yAvg_orig = ySum/numItems;   // calculate the average
   if(yAvg_prev1 >= runThreshold_pos && yAvg_prev1>= yAvg_prev2 && yAvg_prev1>= yAvg && walkReset)
   {
    stepsRan++;
    walkReset = false;
   }
   else if(yAvg_prev1 <= runThreshold_neg && yAvg_prev1<= yAvg_prev2 && yAvg_prev1<= yAvg && !walkReset)
   {
    stepsRan++;
    walkReset = true;
   }
   else if(yAvg_prev1 >= walkThreshold_pos && yAvg_prev1 < runThreshold_pos && yAvg_prev1>= yAvg_prev2 && yAvg_prev1>= yAvg && walkReset)
   {
    stepsWalked++;
    walkReset = false;
   }
   else if(yAvg_prev1 <= walkThreshold_neg && yAvg_prev1 > runThreshold_neg && yAvg_prev1<= yAvg_prev2 && yAvg_prev1<= yAvg && !walkReset)
   {
    stepsWalked++;
    walkReset = true;
   }

   //Serial.print(" ");
   Serial.print(stepsWalked);
   Serial.print(" ");
   Serial.print(stepsRan);
   Serial.print(" ");
   //Serial.print(yAvg_orig);
   //Serial.print(" ");
   Serial.println(yAvg);
   
   delay(10);
 }
}
