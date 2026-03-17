## Centroid Tracking
Centroid Tracking and Analysis code takes xz projection videos and gives a csv file with the z and x position vs time data. The code can handle single video or multiple videos of a single particle at multiple powers, saved in the same directory.

## Frames Picker


## Ellipse Fitting
Takes images of two orthogonal projections (xz and yz) and fits an ellipse on the particle silhouette in both images. The ellipse paramters are saved in a .json file and are used to build a 3D ellipsoid.

## 3D Model
This code takes the ellipsoid paramters from the .json file and generates a 3D ellipsoid. Using fresnel's coefficients, I get the surface absorption at every point on the ellipsoid. The absorption maps of the surface is plotted for different polarisations of the beam.
