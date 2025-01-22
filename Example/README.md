# Example 1

Copy files from this folder into some directory and compile Fortran program

> make

Run exemple:

> ./wtb

```
1-D Laplacian Eigenproblem, n = 100 (Fortran)
 Number of requested eigenvalues:  10
 ierr:   0
 Solution method: krylovschur                                                                     
 Number of requested eigenvalues:  10
 Linear eigensolve converged (10 eigenpairs) due to CONVERGED_TOL; iterations 40
 ---------------------- --------------------
            k             ||Ax-kx||/||kx||
 ---------------------- --------------------
        3.999756            4.19575e-09
        3.999023            9.31525e-09
        3.997802            3.46131e-09
        3.996093            7.97019e-09
        3.993896            1.60115e-09
        3.991212             5.5682e-09
        3.988042            6.69835e-09
        3.984386            7.69882e-09
        3.980245            2.13191e-09
        3.975621            3.77331e-09
 ---------------------- --------------------
 calc time =  0.20098399999999997       s

``` 

Larger test for n=3000 (size of matrix) and nev=1000 (number of solutions)

```
ncv=2000 (subspace) mpd=2000 (projectors)
cores     calc time (s)
  1         227
  2         145
  4         123
128         365
```

```
ncv=1200 (subspace) mpd=400 (projectors)
cores     calc time (s)
  1        113.5
 32         17.1
```

```
ncv=1200 (subspace) mpd=300 (projectors)
cores     calc time (s)
  1         98.0
 32         16.9
```


```
ncv=1200 (subspace) mpd=200 (projectors)
cores     calc time (s)
  1         84.6
  4         28.2
  8         17.2
 16         13.4
 32         12.8
 64         18.2
```

```
ncv=1100 (subspace) mpd=160 (projectors)
cores     calc time (s)
  1         89.9
 32         13.6
 64         20.3
```

```
ncv=1100 (subspace) mpd=100 (projectors) max_it=300
cores     calc time (s)
  1        109.1
 32         13.7
 64         15.2
```



