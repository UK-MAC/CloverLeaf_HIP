!Crown Copyright 2012 AWE.
!
! This file is part of CloverLeaf.
!
! CloverLeaf is free software: you can redistribute it and/or modify it under
! the terms of the GNU General Public License as published by the
! Free Software Foundation, either version 3 of the License, or (at your option)
! any later version.
!
! CloverLeaf is distributed in the hope that it will be useful, but
! WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
! FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
! details.
!
! You should have received a copy of the GNU General Public License along with
! CloverLeaf. If not, see http://www.gnu.org/licenses/.

!>  @brief CloverLeaf top level program: Invokes the main cycle
!>  @author Michael Boulton
!>  @details CLoverLeaf in a proxy-app that solves the compressible Euler

#include "ftocmacros.h"
#include "cuda_common.cu"

#include "chunk_cuda.cu"
extern CloverleafCudaChunk chunk;

__global__ void device_revert_kernel_cuda
(int x_min,int x_max,int y_min,int y_max,
const double* __restrict const density0,
      double* __restrict const density1,
const double* __restrict const energy0,
      double* __restrict const energy1)
{
    __kernel_indexes;

    if(row >= (y_min + 1) && row <= (y_max + 1)
    && column >= (x_min + 1) && column <= (x_max + 1))
    {
        density1[THARR2D(0, 0, 0)] = density0[THARR2D(0, 0, 0)];
        energy1[THARR2D(0, 0, 0)] = energy0[THARR2D(0, 0, 0)];
    }
}

extern "C" void revert_kernel_cuda_
(int *x_min,int *x_max,int *y_min,int *y_max,
const double* density0,
      double* density1,
const double* energy0,
      double* energy1)
{
    chunk.revert_kernel();
}

void CloverleafCudaChunk::revert_kernel
(void)
{
_CUDA_BEGIN_PROFILE_name(device);
    device_revert_kernel_cuda<<< num_blocks, BLOCK_SZ >>>
    (x_min,x_max,y_min,y_max, density0, density1, energy0, energy1);
    errChk(__LINE__, __FILE__);
_CUDA_END_PROFILE_name(device);
}

