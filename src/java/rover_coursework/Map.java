// Internal action code for project ia_submission

package rover_coursework;

import java.util.ArrayList;
import java.util.Arrays;

public class Map {
	private static Map	instance;
	
//	private ArrayList< ArrayList< Character > >	map 				= new ArrayList< ArrayList< Character > >();
	private ArrayList< int[] >					scanLocations		= new ArrayList< int[] >();
	private ArrayList< int[] >					goldLocations		= new ArrayList< int[] >(); ///
	private ArrayList< int[] >					diamondLocations	= new ArrayList< int[] >(); ///
	
	
	
	public Map()
	{
	}
	
	
	
	public void initialise( int mapWidth, int mapHeight, int scanRange )
	{
//		// Create the 2d ArrayList representing the map ///
//		for( int y = 0; y < mapHeight; y++ )
//		{
//			map.add( new ArrayList< Character >() );
//			
//			for( int x = 0; x < mapWidth; x++ )
//			{
//				// Populate the map with '-', representing unexplored tiles
//				map.get( x ).add( '-' );
//			}
//		}
//		
//		// Set location 0,0 to the base		/// this may need to be different for the maze
//		map.get( 0 ).set( 0, 'B' );
		
		
		
		// Get a list of coordinates of scan locations
		int scanDiameter = 2 * scanRange;
		int largestScanX = scanRange * ( ( mapWidth - scanRange ) / scanRange );
		int largestScanY = scanRange * ( ( mapHeight - scanRange ) / scanRange );
		
		for( int y = 0; y <= largestScanY; y += scanRange )
		{
			for( int i = 0; i <= largestScanX; i += scanRange )
			{
				// Make x go highest to lowest on odd rows, so the first point on a new row is closer to the last point on the previous row
				int x = y % scanDiameter == 0 ? i : largestScanX - i; ///
				
				if( ( x % scanDiameter == 0 && y % scanDiameter == 0 && ( x != 0 || y != 0 ) ) || ( x % scanDiameter == scanRange && y % scanDiameter == scanRange ) ) // We start at 0,0, so moving to it would be redundant
				{
					int coordinate[] = { x, y };
					scanLocations.add( coordinate );
				}
			}
		}
	}
	
	
	
	public static Map getInstance()
	{
		if( instance == null )
		{
			instance = new Map();
		}
		
		return instance;
	}
	
	
	
	public int[] getScanLocation()
	{
		int location[] = { -1, -1 };
		
		if( scanLocations.size() > 0 )
		{
			location = scanLocations.get( 0 );
			scanLocations.remove( 0 );
		}
		
		return location;
	}
	
	
	
	public void setResourceInfo( int x, int y, int resourceID, int quantity ) /// check for duplicates
	{
		int resourceInfo[] = { x, y, quantity };
		
		// resourceIDs: gold = 0, diamonds = 1
		if( resourceID == 0 )
		{
			if( !isInList( goldLocations, resourceInfo ) )
			{
				System.out.println( "Map.setResourceInfo - saving to goldLocations" ); /// test
				goldLocations.add( resourceInfo );
			}
		}
		else
		{
			if( !isInList( diamondLocations, resourceInfo ) )
			{
				System.out.println( "Map.setResourceInfo - saving to diamondLocations" ); /// test
				diamondLocations.add( resourceInfo );
			}
		}
	}
	
	public int[] getResourceInfo( int resourceID )
	{
		// The default quantity is -1 (which is impossible for an actual resource) so that if there are no more locations in the given arrayList the function this returns to can check that
		int resourceInfo[] = { 0, 0, -1 };
		
		if( resourceID == 0 && goldLocations.size() > 0 )
		{
			System.out.println( "Map.setResourceInfo - getting next goldLocation" ); /// test
			resourceInfo = goldLocations.get( 0 );
			goldLocations.remove( 0 );
		}
		else if( diamondLocations.size() > 0 )
		{
			System.out.println( "Map.setResourceInfo - getting next diamondLocation" ); /// test
			resourceInfo = diamondLocations.get( 0 );
			diamondLocations.remove( 0 );
		}
		
		return resourceInfo;
	}
	
	
	
	// Helper function to check whether an ArrayList of int arrays contains an int array
	public static boolean isInList( final ArrayList<int[]> list, final int[] candidate)
	{
	    for(final int[] item : list){
	        if( Arrays.equals( item, candidate ) )
	        {
	            return true;
	        }
	    }
	    return false;
	}
}
