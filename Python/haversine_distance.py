import numpy as np

EARTH_RADIUS = 6371.009

def haversine_distance(x, y):
    """Haversine (great circle) distance

    Calculate the great circle distance between two points
    on the earth (specified in decimal degrees)

    Parameters
    ----------
    x : array, shape=(n_samples, 2)
      the first list of coordinates (degrees)
    y : array: shape=(n_samples, 2)
      the second list of coordinates (degress)

    Returns
    -------
    d : array, shape=(n_samples,)
      the distance between corrdinates (km)

    References
    ----------
    https://en.wikipedia.org/wiki/Great-circle_distance
    """
    x_rad = np.radians(x)
    y_rad = np.radians(y)

    d = y_rad - x_rad

    dlat, dlon = d.T
    x_lat = x_rad[:, 0]
    y_lat = y_rad[:, 0]

    a = np.sin(dlat/2.0)**2 + \
        np.cos(x_lat) * np.cos(y_lat) * np.sin(dlon/2.0)**2

    c = 2 * np.arcsin(np.sqrt(a))
    return EARTH_RADIUS * c


# 
x = [[1.2893019,103.8631191]] # Singapore Flyer
y = [[52.528658,13.424639]] # Berlin

haversine_distance(x, y)
