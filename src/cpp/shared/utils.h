#pragma once

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <functional>

#include <Eigen/Dense>
#include <Eigen/StdVector>

#include "light_matrix.h"

#include "defs.h"


typedef struct { int verts[3]; } Triangle;

template<typename T>
using avector = std::vector<T, Eigen::aligned_allocator<T>>;

class HandModelEigen
{
public:
    std::vector<std::string> bone_names;
    std::vector<int> parents; // assumimng that parent is earlier in the order of bones
    avector<Eigen::Matrix4d> base_relatives;
    avector<Eigen::Matrix4d> inverse_base_absolutes;
    Eigen::Matrix3Xd base_positions;
    Eigen::ArrayXXd weights;
    std::vector<Triangle> triangles;
    bool is_mirrored;
};

class HandDataEigen
{
public:
    HandModelEigen model;
    std::vector<int> correspondences;
    Eigen::Matrix3Xd points;
};


class HandModelLightMatrix
{
public:
    std::vector<std::string> bone_names;
    std::vector<int> parents; // assumimng that parent is earlier in the order of bones
    std::vector<LightMatrix<double>> base_relatives;
    std::vector<LightMatrix<double>> inverse_base_absolutes;
    LightMatrix<double> base_positions;
    LightMatrix<double> weights;
    std::vector<Triangle> triangles;
    bool is_mirrored;
};

class HandDataLightMatrix
{
public:
    HandModelLightMatrix model;
    std::vector<int> correspondences;
    LightMatrix<double> points;
};

// rows is nrows+1 vector containing
// indices to cols and vals. 
// rows[i] ... rows[i+1]-1 are elements of i-th row
// i.e. cols[row[i]] is the column of the first
// element in the row. Similarly for values.
class BASparseMat
{
public:
    int n, m, p; // number of cams, points and observations
    int nrows, ncols;
    std::vector<int> rows;
    std::vector<int> cols;
    std::vector<double> vals;

    BASparseMat();
    BASparseMat(int n_, int m_, int p_);

    void insert_reproj_err_block(int obsIdx,
        int camIdx, int ptIdx, const double* const J);

    void insert_w_err_block(int wIdx, double w_d);

    void clear();
};

void read_gmm_instance(const std::string& fn,
    int* d, int* k, int* n,
    std::vector<double>& alphas,
    std::vector<double>& means,
    std::vector<double>& icf,
    std::vector<double>& x,
    Wishart& wishart,
    bool replicate_point);

void read_ba_instance(const std::string& fn,
    int& n, int& m, int& p,
    std::vector<double>& cams,
    std::vector<double>& X,
    std::vector<double>& w,
    std::vector<int>& obs,
    std::vector<double>& feats);

struct write_J_stream : public std::ofstream
{
    write_J_stream(std::string fn, size_t rows, size_t cols);
};

void write_J_sparse(const std::string& fn, const BASparseMat& J);

void write_J(const std::string& fn, int Jrows, int Jcols, double** J);

void write_J(const std::string& fn, int Jrows, int Jcols, double* J);

void write_times(double tf, double tJ);

void write_times(const std::string& fn, double tf, double tJ, double* t_sparsity = nullptr);

//#ifdef DO_EIGEN
void read_hand_model(const std::string& path, HandModelEigen* pmodel);

void read_hand_instance(const std::string& model_dir, const std::string& fn_in,
    std::vector<double>* theta, HandDataEigen* data, std::vector<double>* us = nullptr);
//#endif

void read_hand_model(const std::string& path, HandModelLightMatrix* pmodel);

void read_hand_instance(const std::string& model_dir, const std::string& fn_in,
    std::vector<double>* theta, HandDataLightMatrix* data, std::vector<double>* us = nullptr);

void read_lstm_instance(const std::string& fn,
    int* l, int* c, int* b,
    std::vector<double>& main_params,
    std::vector<double>& extra_params,
    std::vector<double>& state,
    std::vector<double>& sequence);

// Time a function
double timer(int nruns, double limit, std::function<void()> func);