import java.io.*;
import java.util.Locale;

import jaci.pathfinder.*;
import jaci.pathfinder.modifiers.TankModifier;
public class TrajectoryGenerator {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//Conversion from metric to imperial
		final double M2FT = 3.28084;
		final double FT2M = 1/M2FT;
		
		String filename = "traj.csv";
		boolean wantHeaders   = false;
		boolean backwardsTraj = false;
		
		double wheelbase_cm = 71.0; //cm
        double wheelbase_m  = wheelbase_cm/100.0;
        
		//Trajectory Config Parms
		final double TIME_STEP = 0.05; // Seconds
		final double MAX_VEL = 1.5;    // m/s
		final double MAX_ACC = 1;    // m/s/s
		final double MAX_JERK = 6.0;  // m/s/s/s
		Trajectory.Config config = new Trajectory.Config(Trajectory.FitMethod.HERMITE_CUBIC, Trajectory.Config.SAMPLES_HIGH, TIME_STEP, MAX_VEL, MAX_ACC, MAX_JERK);
        Waypoint[] points = new Waypoint[] {
//        		new Waypoint(0,0,0),
//        		new Waypoint(10, 0, 0)
        		
        		
                new Waypoint(((33.0/12.0)*FT2M/2.0), -.127, 0),
                new Waypoint(3.2, 1.2, Pathfinder.d2r(10)),
//                new Waypoint(3.2, -1.2, Pathfinder.d2r(-10)),
//                new Waypoint(12, -4, Pathfinder.d2r(-90)),
//                new Waypoint(12, -15, Pathfinder.d2r(-90)),              
//                new Waypoint(14, -17, Pathfinder.d2r(0))    
                
//                new Waypoint(.5, 0, 0),
//                new Waypoint((2.58+2.1)/2, 3.64/2, Pathfinder.d2r(-45)),
//                new Waypoint(7.8, -3.64, Pathfinder.d2r(-30))
        };

        Trajectory trajectory = Pathfinder.generate(points, config);

        TankModifier modifier = new TankModifier(trajectory).modify(wheelbase_m);

        // Do something with the new Trajectories...
        Trajectory left = modifier.getLeftTrajectory();
        Trajectory right = modifier.getRightTrajectory();
        
        if(backwardsTraj) {
        	//flip left and right
            right = modifier.getLeftTrajectory();
            left = modifier.getRightTrajectory();
        	//negate everything
            
        	//add 180 deg to angle (might solve itself with the flipping of left and right
        }
        else {
        	// Do something with the new Trajectories...
            left = modifier.getLeftTrajectory();
            right = modifier.getRightTrajectory();
        }
        
        System.out.println("Done");
        System.out.println("Left segment length: "  + left.length());        
        System.out.println("Right segment length: " + right.length());

        if (left.length() != right.length()) {
        	System.out.println("ERROR! LEFT and RIGHT Trajectories do not have the same length.");
        }
        
        //Calculate total elapsed time, and angle
        double[] left_t    = new double[left.length()];
        double[] right_t   = new double[right.length()];
        double[] angle_deg = new double[left.length()];
        left_t[0] = 0; 
        right_t[0] = 0;
    	angle_deg[0] = Pathfinder.r2d(Math.atan2(left.get(0).y-right.get(0).y, left.get(0).x-right.get(0).x))-90;
        for(int i = 1; i < left.length(); i++) {
        	left_t[i] = left_t[i-1] + left.get(i-1).dt;
        	right_t[i] = right_t[i-1] + right.get(i-1).dt;
        	double y2 = left.get(i).y;
        	double y1 = right.get(i).y;
        	double x2 = left.get(i).x;
        	double x1 = right.get(i).x;
        	
        	angle_deg[i] = Pathfinder.r2d(Math.atan2(y2-y1, x2-x1))-90;
        }
//        for(int i = 1; i < right.length(); i++) {
//        	right_t[i] = right_t[i-1] + right.get(i-1).dt;
//        }

        
        try(PrintWriter out = new PrintWriter(filename)) {
        	if(wantHeaders) {
        		out.printf("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
        				"leftX","leftY","rightX","rightY","leftPos","rightPos","leftVel","rightVel",
        				"leftAcc","rightAcc","leftJerk","rightJerk","leftDt","rightDt",
        				"leftTime","rightTime","angle"
        				);
        	}
        	int backMult = backwardsTraj ? -1 : 1;
        	for(int i =0; i < left.length(); i ++) {
	        	out.printf(String.format(Locale.US,"%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n", 
	        			left.get(i).x,                     left.get(i).y, 
	        			right.get(i).x,                    right.get(i).y, 
	        			backMult*left.get(i).position,     backMult*right.get(i).position,
	        			backMult*left.get(i).velocity,     backMult*right.get(i).velocity,
	        			backMult*left.get(i).acceleration, backMult*right.get(i).acceleration,
	        			backMult*left.get(i).jerk,         backMult*right.get(i).jerk,
	        			left.get(i).dt,                    right.get(i).dt,
	        			left_t[i],                         right_t[i],
	        			angle_deg[i]));
	        }
        } catch (java.io.FileNotFoundException e) {
        	
        }
    }

}
