# miniature-engine
## k-Nearest neighbor smoother
The **k-Nearest neighbor smoother** is a centered smoother to gauge the underlying trends of noisy data. In this chart I simulate a sine wave with gaussian noise and use the kNN smoother. The smoother is straightforward in simplicity as it averages the **k** closest values to each x. It is required for k to be an odd number such that there are an equal number of values to the left and to the right of x. End points where there aren't enough values on one side do not have smoothed values.
![chart of simulated data with smoother](https://github.com/frogger21/miniature-engine/blob/master/kNNsmoothed.PNG)

We can modify the smoother to become a **one-sided k-Nearest neighbor smoother**. The one sided version gives persistent bias to the upside or downside while the centered version is closer to the *truth*.
![chart of one sided smoother](https://github.com/frogger21/miniature-engine/blob/master/onesided3.PNG)
