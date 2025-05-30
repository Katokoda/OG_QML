
# Insert the name as they will be present in the DATA
# And in top-to-bottom order according to GUI
PLANE_NAMES = ["Indiv.", "Team", "Class"]

def intFromPlane(string : str):
    # Convert a string representing the plane to an int
    return PLANE_NAMES.index(string)
        
def planeFromInt(idx : int):
    # Convert a string representing the plane to an int
    if 0 <= idx < len(PLANE_NAMES):
        return PLANE_NAMES[idx]
    else:
        raise ValueError('Error - planeFromInt: invalid idx.')