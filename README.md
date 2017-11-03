###################################################################
#                                                                 #
#    IELM V1.0                                             #
#    Limeng Cui (lmcui932-at-163.com)                             #
#                                                                 #
###################################################################

1.Introduction.

Inverse Extreme Learning Machine (IELM) is a very fast proportion learning method based on inversing output scaling process and extreme learning machine.

Part of the Matlab code is supported on Felix Yu’s pSVM package (https://github.com/felixyu/pSVM) and basic ELM codes (http://www3.ntu.edu.sg/home/egbhuang/elm_codes.html).

If you use the IELM, we appreciate it if you cite an appropriate subset of the following papers:

@inproceedings{cui2017inverse,<br />
&nbsp;&nbsp;title={Inverse Extreme Learning Machine for Learning with Label Proportions},<br />
&nbsp;&nbsp;author={Cui, Limeng and Zhang, Jiawei and Chen, Zhensong and Shi, Yong and Yu, Philip S.},<br />
&nbsp;&nbsp;booktitle={Proceedings of IEEE International Conference on Big Data},<br />
&nbsp;&nbsp;year={2017},<br />
}

@article{shi2017learning,<br />
&nbsp;&nbsp;title={Learning from label proportions with pinball loss},<br />
&nbsp;&nbsp;author={Shi, Yong and Cui, Limeng and Chen, Zhensong and Qi, Zhiquan},<br />
&nbsp;&nbsp;journal={International Journal of Machine Learning and Cybernetics},<br />
&nbsp;&nbsp;year={2016},<br />
&nbsp;&nbsp;publisher={Springer}<br />
}

###################################################################

2.License.

The software is made available for non-commercial research purposes only.

###################################################################

3.Installation.

a) This code is written for the Matlab interpreter (tested with versions R2014b). 

b) Additionally, CVX, gurobi, and libsvm is also required.
http://cvxr.com/cvx/
http://www.gurobi.com/
http://www.csie.ntu.edu.tw/~cjlin/libsvm/
Please download the software in the above websites, and setup init.m accordingly.

###################################################################

4.Getting Started.

 - Make sure to carefully follow the installation instructions above.
 - Please see "demo_elm" and "demo_baselines" to run demos.

###################################################################

5.History.

Version 1.0 (11/02/2017)
 - initial version

###################################################################