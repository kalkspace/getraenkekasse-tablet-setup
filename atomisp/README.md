# atomisp

**ATOMISP DOESN'T WORK**

This prepares the atomisp module from a linux kernel to be compiled as a DKMS.

DKMS allows us to manage modules after the kernel has been compiled.

The atomisp driver is considered unstable and thus not included in a standard kernel
and instead of recompiling everything I think compiling just the module
makes more sense.

Unfortunately the camera will just not work on a Dell Venue 11 Pro 5130
because the baytrail platform fails to work with the camera module on linux.
