import java.io.*;

import jaci.pathfinder.*;
import jaci.pathfinder.modifiers.TankModifier;
public class TrajectoryGenerator {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//Conversion from metric to imperial
		final double M2FT = 3.28084;
		final double FT2M = 1/M2FT;
		
		//Trajectory Config Parms
		final double TIME_STEP = 0.05; // Seconds
		final double MAX_VEL = 4;    // ft/s
		final double MAX_ACC = 10.0;    // ft/s/s
		final double MAX_JERK = 60.0;  // ft/s/s/s
		Trajectory.Config config = new Trajectory.Config(Trajectory.FitMethod.HERMITE_CUBIC, Trajectory.Config.SAMPLES_HIGH, TIME_STEP, MAX_VEL, MAX_ACC, MAX_JERK);
        Waypoint[] points = new Waypoint[] {
//        		new Waypoint(0,0,0),
//        		new Waypoint(10, 0, 0)
        		
        		
                new Waypoint(0, 0, 0),
                new Waypoint(8, 0, Pathfinder.d2r(0)),
                new Waypoint(12, -4, Pathfinder.d2r(-90)),
                new Waypoint(12, -15, Pathfinder.d2r(-90)),              
                new Waypoint(14, -17, Pathfinder.d2r(0))    
                
//                new Waypoint(.5, 0, 0),
//                new Waypoint((2.58+2.1)/2, 3.64/2, Pathfinder.d2r(-45)),
//                new Waypoint(7.8, -3.64, Pathfinder.d2r(-30))
        };

        Trajectory trajectory = Pathfinder.generate(points, config);

        // Wheelbase Width = 0.5m
        double wheelbase_in = 27; //in
        double wheelbase_ft  = wheelbase_in/12;
        TankModifier modifier = new TankModifier(trajectory).modify(wheelbase_ft);

        // Do something with the new Trajectories...
        Trajectory left = modifier.getLeftTrajectory();
        Trajectory right = modifier.getRightTrajectory();
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
        left_t[0] = 0; right_t[0] = 0; angle_deg[0] = 0;
        for(int i = 1; i < left.length(); i++) {
        	left_t[i] = left_t[i-1] + left.get(i-1).dt;
        	right_t[i] = right_t[i-1] + right.get(i-1).dt;
        	double y2 = trajectory.get(i).y;
        	double y1 = trajectory.get(i-1).y;
        	double x2 = trajectory.get(i).x;
        	double x1 = trajectory.get(i-1).x;
        	
        	angle_deg[i] = Pathfinder.r2d(Math.atan2(y2-y1, x2-x1));
        }
//        for(int i = 1; i < right.length(); i++) {
//        	right_t[i] = right_t[i-1] + right.get(i-1).dt;
//        }

        
        try(PrintWriter out = new PrintWriter("traj.csv")) {
	        for(int i =0; i < left.length(); i ++) {
	        	out.printf("%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n", 
	        			left.get(i).x, left.get(i).y, 
	        			right.get(i).x, right.get(i).y, 
	        			left.get(i).position, right.get(i).position,
	        			left.get(i).velocity, right.get(i).velocity,
	        			left.get(i).acceleration, right.get(i).acceleration,
	        			left.get(i).jerk, right.get(i).jerk,
	        			left.get(i).dt, right.get(i).dt,
	        			left_t[i],right_t[i],
	        			angle_deg[i]);
	        }
        } catch (java.io.FileNotFoundException e) {
        	
        }
    }

}
