# calcium imaging ROI analysis
We performed calcium imaging experiments on cultures containing a mixture of GFP+ and CFP+ neurons using the red shifted calcium sensitive dye Rhodamine3. This code calculates the mean Rhod3 fluorescence intensity of user identified ROIs for CFP+, GFP+, and CFP-/GFP- Rhod3+ neurons. Since the GFP+ neurons show up on both the GFP and CFP channels, whereas the CFP+ neurons only show up on the CFP channel, we perform identification of GFP+ neurons first, then identify CFP+ neurons as ones that show up on the CFP channel but not the GFP channel. 

### Running the code
To start, specify the directory where the raw GFP, CFP, and Rhod3 .tif images are located in `fpath` along with the names of these files in `gfpnom`, `cfpnom`, and `canom`. This code also has the option of analyzing experiments with just GFP or CFP data, in which case set the variables `is_gfp` and `is_cfp` accordingly (1 if that channel is used, 0 if not). 

To start, the program will bring up the GFP image, which contains one GFP+ neuron:
![gfp cell](/readme_screenshots/gfp1.png)
```
cells to identify? (y=1) : 1
click top left corner of ROI, then return
```
We select the top left corner of the cell body:
![gfp ROI1](/readme_screenshots/gfp2.png)
The program automatically stores this coordinate once you click return.
```
click bottom right corner of ROI, then return
```
![gfp ROI2](/readme_screenshots/gfp3.png)

The program then draws a box around the identified ROI, bounded by these two points:
![gfp full ROI](/readme_screenshots/gfp4.png)
If you're not happy with the ROI, you can select 0 and draw it again

```
good roi? (y=1,n=0)
```
Otherwise, the program will prompt the user to identify more ROIs. But this is the only GFP+ cell in the image, so we move on to the CFP channel

```
find another cell? (y=0,n=0) : 0
```
The GFP+ neuron ROI that we identified in the previous image carries over to this image so that we don't end up tagging that neuron twice. So now, we can identify ROIs for the neurons that only show up on this channel:

![CFP image](/readme_screenshots/cfp1.png)
```
click top left corner of ROI, then return
```

![CFP ROI1](/readme_screenshots/cfp2.png)
```
click bottom right corner of ROI, then return
```

![CFP ROI2](/readme_screenshots/cfp3.png)

```
good roi? (y=1, n=0) : 1
```

![CFP full ROI](/readme_screenshots/cfp4.png)

We repeat this process for the other CFP+ neurons in the image:

```
find another cell? (y=1,n=0) : 1
```

![all CFP cells](/readme_screenshots/cfp5.png)

Then, the program pulls up the first image of the Rhodamine channel stack and prompts us to identify any neurons that were not previously tagged as GFP+ or CFP+ cells:

![rhod](/readme_screenshots/rhod1.png)

We use the same ROI selection process to identify 4 more cell bodies:

![rhod ROIs](/readme_screenshots/rhod2.png)

Finally, the program takes all of these user defined ROIs and calculates the mean Rhodamine3 channel intensity for each frame of the stack and plots a normalized version of this, color coded according to the cell type:

![fluor intensity](/readme_screenshots/means.png)

This plot, along with the GFP, CFP, and Rhod3 images with designated ROIs are saved in a subdirectory with the name specified by `canom`. The program also saves the ROI coordinates and mean fluorescence intensities for all identified cells for further analysis. 
