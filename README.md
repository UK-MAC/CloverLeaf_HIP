# CloverLeaf HIP

A HIP port of the CloverLeaf mini-app starting from the current CUDA version on UK-MAC. This port used hipify-perl (https://github.com/ROCm-Developer-Tools/HIPIFY) to convert the CUDA kernels. Extra work was required for CUDA specific code (references to specific warpsizes relevant to Nvidia hardware etc.).

## Compiling

In most cases one needs to load the appropriate modules (including those for the accelerator in question).

Then for AMD GPUs (with the Cray compiler)

```
make clean; make COMPILER=CRAY
```

## Extra clover.in flags

Turn on HIP kernel use insert `use_cuda_kernels` in clover.in.

## Performance

Observed performance uplift compared to directive based versions (OpenMP, OpenACC) is anywhere from 20-30% depending on node count for a sufficiently large enough benchmark to make using a GPU sensible. This is consistent with performance observed for the CUDA version of CloverLeaf.
