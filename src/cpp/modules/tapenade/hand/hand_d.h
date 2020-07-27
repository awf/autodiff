/*        Generated by TAPENADE     (INRIA, Ecuador team)
    Tapenade 3.15 (feature_bugFixes) - 20 Jul 2020 19:01
*/
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include <stdlib.h>
#include <math.h>
#include "../../../shared/defs.h"
typedef struct {
    int nrows;
    int ncols;
    double *data;
// matrix is stored in data COLUMN MAJOR!!!
} Matrix;
typedef struct {
    double *data;
} Matrix_diff;
// theta: 26 [global rotation, global translation, finger parameters (4*5)]
// bone_count, bone_names, parents, base_relatives, inverse_base_absolutes,
// base_positions, weights, triangles, is_mirrored, corresp_count, correspondencies: data measurements and hand model
// err: 3*number_of_correspondences
void hand_objective(const double *theta, int bone_count, const char **
    bone_names, const int *parents, Matrix *base_relatives, Matrix *
    inverse_base_absolutes, Matrix *base_positions, Matrix *weights, const 
    Triangle *triangles, int is_mirrored, int corresp_count, const int *
    correspondences, Matrix *points, double *err);
void hand_objective_d(const double *theta, const double *thetad, int 
    bone_count, const char **bone_names, const int *parents, Matrix *
    base_relatives, Matrix_diff *base_relativesd, Matrix *
    inverse_base_absolutes, Matrix_diff *inverse_base_absolutesd, Matrix *
    base_positions, Matrix_diff *base_positionsd, Matrix *weights, const 
    Triangle *triangles, int is_mirrored, int corresp_count, const int *
    correspondences, Matrix *points, double *err, double *errd);
// theta: 26 [global rotation, global translation, finger parameters (4*5)]
// us: 2*number_of_correspondences
// bone_count, bone_names, parents, base_relatives, inverse_base_absolutes,
// base_positions, weights, triangles, is_mirrored, corresp_count, correspondencies: data measurements and hand model
// err: 3*number_of_correspondences
void hand_objective_complicated(const double *theta, const double *us, int 
    bone_count, const char **bone_names, const int *parents, Matrix *
    base_relatives, Matrix *inverse_base_absolutes, Matrix *base_positions, 
    Matrix *weights, const Triangle *triangles, int is_mirrored, int 
    corresp_count, const int *correspondences, Matrix *points, double *err);
void hand_objective_complicated_d(const double *theta, const double *thetad, 
    const double *us, const double *usd, int bone_count, const char **
    bone_names, const int *parents, Matrix *base_relatives, Matrix_diff *
    base_relativesd, Matrix *inverse_base_absolutes, Matrix_diff *
    inverse_base_absolutesd, Matrix *base_positions, Matrix_diff *
    base_positionsd, Matrix *weights, const Triangle *triangles, int 
    is_mirrored, int corresp_count, const int *correspondences, Matrix *points
    , double *err, double *errd);

#ifdef __cplusplus
}
#endif

