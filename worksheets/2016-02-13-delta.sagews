︠3996300c-e97a-4905-90e6-350fadb653fei︠
%md
# The weight 12 modular form $\Delta$.

︡2f9710cf-5815-4c12-9fee-84de74ca4243︡︡{"done":true,"md":"# The weight 12 modular form $\\Delta$."}
︠6b9eef1e-ebec-47db-b488-62b59bdaa62a︠
%time
B = 10^6
f = delta_qexp(B)
w = prime_range(B)
v = [f[p] for p in w]
︡838411fd-970c-4874-b247-ebd32b5011ca︡︡{"stdout":"CPU time: 4.12 s, Wall time: 4.30 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠69f070c0-22a0-4d73-bebb-4ffd9f1a52fei︠
%md
Scaling factor is $p^{(k-1)/2}$, and $k=12$ now so $p^{11/2}$
︡d91e7b4a-ed9c-4ee0-9233-ef7df43fbe78︡︡{"done":true,"md":"Scaling factor is $p^{(k-1)/2}$, and $k=12$ now so $p^{11/2}$"}
︠7708fcbb-846b-4ca4-805f-36c815628a35s︠
t = stats.TimeSeries([float(v[i])/math.sqrt(float(w[i])**11r) for i in range(len(v))])
t.plot_histogram(bins=200, aspect_ratio=1)
︡897b9715-0c8a-4b9c-a4f3-297a0f5d718d︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"0afd3186-24d6-4251-a9f3-55d66b162648","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/27211/tmp_xqMRoq.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠8be29272-e7ec-42eb-ba2f-44d987485770s︠
t_sums = t.sums()
t_sums.plot(figsize=[8,3])
︡b112eceb-ddea-4f3e-b200-21f3e7ae7db6︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"40e31678-e073-4768-9fc0-0c00534231d3","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/27211/tmp_18wKCb.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠a4a49abf-7fd0-4a55-b129-b79c57db9066i︠
%md

Cesaro sum -- $$\frac{1}{\pi(X)} \sum_{p\leq X} \frac{a_p}{p^{11/2}}\ \ \ \sim \ \ \ \frac{\log(X)}{X} \sum_{p\leq X} \frac{a_p}{p^{11/2}} $$

This goes to 0, since we're just taking the average of values sampled from a semicircle distribution.
︡e7f4e5e2-6a5e-44ac-9e6e-ccb3fe3d5d9e︡︡{"done":true,"md":"\nCesaro sum -- $$\\frac{1}{\\pi(X)} \\sum_{p\\leq X} \\frac{a_p}{p^{11/2}}\\ \\ \\ \\sim \\ \\ \\ \\frac{\\log(X)}{X} \\sum_{p\\leq X} \\frac{a_p}{p^{11/2}} $$\n\nThis goes to 0, since we're just taking the average of values sampled from a semicircle distribution."}
︠2e4719ab-c282-4fe5-b4fa-7b386f080f50s︠
t_sums_avg = stats.TimeSeries([t_sums[i]/(i+1r) for i in range(len(t))])
t_sums_avg.plot(figsize=[8,3], ymin=0, ymax=0.01)
︡e2d7bbef-16fc-4344-b31c-58b3f8288d7d︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"d7e7eb0c-712e-4177-8477-7a53ca65e3b4","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/27211/tmp_vVU_E7.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠38c33349-1871-4faf-8a4b-b82a1ef30378︠

︠5288d2b3-93b9-4e14-aadb-427856f3b62di︠
%md
Multiplying the above by $\sqrt{X}$ yields the **medium well data**, maybe!?

This is $\frac{\log(X)}{\sqrt{X}} \sum \frac{a_p}{p^{11/2}}$.
︡43c1b5f0-85e1-4895-a3b9-5b7c6fb745ae︡︡{"done":true,"md":"Multiplying the above by $\\sqrt{X}$ yields the **medium well data**, maybe!?\n\nThis is $\\frac{\\log(X)}{\\sqrt{X}} \\sum \\frac{a_p}{p^{11/2}}$."}
︠a25e74fc-d12d-435b-afce-fd412161eb4es︠
t_sums2 = stats.TimeSeries([t_sums[i]*math.log(float(w[i]))/math.sqrt(float(w[i])) for i in range(len(t))])
︡47679019-9f9a-4394-bafe-2a1a6be10e81︡︡{"done":true}
︠17bae5da-a464-40fe-b8c3-ede6ae58dbfcs︠
t_sums2.plot(figsize=[8,3], ymin=0)
︡ae66db23-4980-420a-95b2-41ec2e53ab82︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"a0dfae8e-37d5-42aa-811e-aa5e8b006dfd","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/27211/tmp_pG2LsK.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠5157a9d6-9a54-479d-b380-dfe8518c8080i︠
%md
Cesaro sum of the medium well data.
︡43fead4c-78d8-4ede-892f-bbfaddff78c8︡︡{"done":true,"md":"Cesaro sum of the medium well data."}
︠3e2d143e-9568-410a-b075-5d26b4052036s︠
t_sums2_sums = t_sums2.sums()
t_sums2_sums_avg = stats.TimeSeries([t_sums2_sums[i]/(i+1) for i in range(len(t))])
︡56f4cf08-5fbb-403d-a064-0a0f567d5b77︡︡{"done":true}
︠9a3956ac-2069-4fce-91a8-455c800f7bb7s︠
t_sums2_sums_avg
︡c5d2fb06-b0c5-4266-aaae-caa27369f0a6︡︡{"stdout":"[-0.2599, -0.1083, 0.1101, 0.1530, 0.3225 ... 1.2589, 1.2589, 1.2589, 1.2589, 1.2589]\n","done":false}︡{"done":true}
︠e2c09a66-35c0-4467-8c63-d2e03faa108fs︠
t_sums2_sums_avg.plot(figsize=[8,3], ymin=0, ymax=3)
︡92631c63-8bbc-4987-9d53-5f7753eeebdd︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"a94c7d63-287b-4f48-8c4a-d835d4391ca0","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/27211/tmp_YufA_4.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠605b0eb5-b46f-4753-ba10-f1ebb47b44eci︠
%md
Variance?  Here's the variance of the medium well data as a function of $X$ (the $x$-axis in the plot is $i$ so that $p_i = X$).

I'm just computing the variance of the first $100n$ terms of the sum as $n$ increases to $10^7$.
︡f383a09f-2cbb-49b2-ac0a-23050cb63a2e︡︡{"done":true,"md":"Variance?  Here's the variance of the medium well data as a function of $X$ (the $x$-axis in the plot is $i$ so that $p_i = X$).\n\nI'm just computing the variance of the first $100n$ terms of the sum as $n$ increases to $10^7$."}
︠14581fd5-0900-4c92-812a-f5ee47ce31ecs︠
%time t_sums2_var = stats.TimeSeries([t_sums2[:i*100].variance() for i in range(1,len(t_sums2)//100)])
︡7c5017cd-e69b-4ed8-a842-d55b57ff6125︡︡{"stdout":"CPU time: 0.10 s, Wall time: 0.10 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠9adc211a-61d8-4d21-946f-bab8b5e5db11s︠
t_sums2_var.plot(ymax=.35, figsize=[12,3])
︡43736026-5099-4538-b72b-4d469601ee87︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"2e5d5343-bdb0-4a42-95e5-2a6aa164956f","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/27211/tmp_dWAM9T.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠27e6c096-202c-44ba-93fb-991519730f05s︠
# Double check: should be just like Cesaro  (yep)
%time t_sums2_mean = stats.TimeSeries([t_sums2[:i*100].mean() for i in range(1,len(t_sums2)//100)])
t_sums2_mean.plot(ymax=2, figsize=[12,3])
︡57cc4c50-9daa-4976-8196-c1bda84d1373︡︡{"stdout":"CPU time: 0.06 s, Wall time: 0.06 s\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"0be6e399-125c-42a9-aa3f-1a0fa36837c5","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/27211/tmp_iNQGpq.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠1a4e2ac1-537d-4cfa-bb5c-d9554a720b9es︠
# significant variance even near the end... (these are the last 1000 terms)
t_sums2[-1000:].plot()
︡c203d2fc-7b29-44dd-9dc9-ff99b3153afc︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"3167bc3f-65bc-457a-bfa7-c2a63036bb77","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/27211/tmp_JhE5za.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠5b9cd08c-4cd9-4bcb-998d-dc25dd62fb05︠











