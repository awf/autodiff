% Copyright (c) Microsoft Corporation.
% Licensed under the MIT license.

function err = ba_compute_reproj_err(cam,X,w,feat)

i_rot = 1:3;
i_C = 4:6;
i_f = 7;
i_princ_pt = 8:9;
i_rad_params = 10:11;

Xo = X - cam(i_C);
Xcam = rodrigues_rotate_point(cam(i_rot),Xo);
Xcam_e = Xcam(1:end-1)/Xcam(end);
distorted = radial_distort(cam(i_rad_params),Xcam_e);
proj = distorted * cam(i_f) + cam(i_princ_pt);

err = w*(proj - feat);

end

function rotatedPt = rodrigues_rotate_point(rot,pt)
sqtheta = sum(rot.^2);
if sqtheta ~= 0
    theta = sqrt(sqtheta);
    costheta = cos(theta);
    sintheta = sin(theta);
    theta_inverse = 1. / theta;
    
    w = rot * theta_inverse;
    w_cross_pt = cross(w,pt);
    tmp = (1. - costheta) * (w'*pt);
    
    rotatedPt = costheta*pt + sintheta*w_cross_pt + tmp*w;
else
    rot_cross_pt = cross(rot,pt);
    rotatedPt = pt + rot_cross_pt;
end
end

function x = radial_distort(kappa,x) 
    sqr = sum(x.^2);
    L = 1 + kappa(1)*sqr + kappa(2)*sqr*sqr;
    x = x * L;
end