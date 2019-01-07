###################################################################
#                                                                 #
#    IELM V1.0                                                    #
#    Limeng Cui (lmcui932-at-gmail.com)                           #
#                                                                 #
###################################################################

1.Introduction.

Inverse Extreme Learning Machine (IELM) is a very fast proportion learning method based on inversing output scaling process and extreme learning machine.

Part of the Matlab code is supported on Felix Yu’s pSVM package (https://github.com/felixyu/pSVM) and basic ELM codes (http://www3.ntu.edu.sg/home/egbhuang/elm_codes.html).

If you use the IELM, we appreciate it if you cite an appropriate subset of the following papers:

@inproceedings{cui2017inverse,<br />
&nbsp;&nbsp;title={Inverse extreme learning machine for learning with label proportions},<br />
&nbsp;&nbsp;author={Cui, Limeng and Zhang, Jiawei and Chen, Zhensong and Shi, Yong and Philip, S Yu},<br />
&nbsp;&nbsp;booktitle={Big Data (Big Data), 2017 IEEE International Conference on},<br />
&nbsp;&nbsp;pages={576--585},<br />
&nbsp;&nbsp;year={2017},<br />
&nbsp;&nbsp;organization={IEEE}<br />
}

@article{shi2017learning,<br />
&nbsp;&nbsp;title={Learning from label proportions with pinball loss},<br />
&nbsp;&nbsp;author={Shi, Yong and Cui, Limeng and Chen, Zhensong and Qi, Zhiquan},<br />
&nbsp;&nbsp;journal={International Journal of Machine Learning and Cybernetics},<br />
&nbsp;&nbsp;pages={1--19},<br />
&nbsp;&nbsp;year={2017},<br />
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