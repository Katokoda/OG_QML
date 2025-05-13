
PLANE_NAMES = ["Class", "Team", "Individual"]

def intFromPlane(string : str):
    # Convert a string representing the plane to an int
    if string == "Class":
        return 0
    elif string == "Team":
        return 1
    elif string == "Individual":
        return 2
    else:
        print("Error - intFromPlane: unknown plane")
        1/0
        
def planeFromInt(idx : int):
    # Convert a string representing the plane to an int
    if 0 <= idx < len(PLANE_NAMES):
        return PLANE_NAMES[idx]
    else:
        print("Error - planeFromInt: invalid idx")
        1/0