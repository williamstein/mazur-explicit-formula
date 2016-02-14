︠415a3f95-9899-4680-bc7f-367ccf0a3507s︠
%time
B = 10^7
E = EllipticCurve('11a')
v = E.aplist(B)
w = prime_range(B)
︡3c809ea5-e11a-45b7-927d-c25e320335ef︡︡{"stdout":"CPU time: 66.99 s, Wall time: 68.96 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠88b3acd1-5997-4838-a3f6-68f77623b6dds︠
t = stats.TimeSeries([float(v[i])/math.sqrt(float(w[i])) for i in range(len(v))])
t.plot_histogram(bins=200, aspect_ratio=1)
︡918a4c49-50fb-4c40-938f-a2402e282c78︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"db888373-dc2c-4d76-9f7a-b3cb402f1634","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/31088/tmp_mLwU9z.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠c15efc5a-3f59-4bc5-9d42-87dfe5e6e1f3s︠
t_sums = t.sums()
t_sums.plot(figsize=[8,3])
︡c10e23ce-bd28-46fb-a68d-5f2f1c706741︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"9678dc24-2e4b-4ab3-8bdc-5feffb379c27","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/31088/tmp_GpQCLM.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠a4a49abf-7fd0-4a55-b129-b79c57db9066i︠
%md

Cesaro sum -- $$\frac{1}{\pi(X)} \sum_{p\leq X} \frac{a_p}{\sqrt{p}}\ \ \ \sim \ \ \ \frac{\log(X)}{X} \sum_{p\leq X} \frac{a_p}{\sqrt{p}} $$

This goes to 0, since we're just taking the average of values sampled from a semicircle distribution.
︡e7f4e5e2-6a5e-44ac-9e6e-ccb3fe3d5d9e︡︡{"done":true,"md":"\nCesaro sum -- $$\\frac{1}{\\pi(X)} \\sum_{p\\leq X} \\frac{a_p}{\\sqrt{p}}\\ \\ \\ \\sim \\ \\ \\ \\frac{\\log(X)}{X} \\sum_{p\\leq X} \\frac{a_p}{\\sqrt{p}} $$\n\nThis goes to 0, since we're just taking the average of values sampled from a semicircle distribution."}
︠2e4719ab-c282-4fe5-b4fa-7b386f080f50s︠
t_sums_avg = stats.TimeSeries([t_sums[i]/(i+1r) for i in range(len(t))])
t_sums_avg.plot(figsize=[8,3], ymin=0, ymax=0.0035)
︡cc4b6afe-eb5f-454e-a54b-80b981e93834︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"b3b2a03b-e742-4463-8145-5ca5a62b8942","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/31088/tmp_vB_eHH.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠38c33349-1871-4faf-8a4b-b82a1ef30378︠

︠5288d2b3-93b9-4e14-aadb-427856f3b62di︠
%md
Multiplying the above by $\sqrt{X}$ yields the **medium well data**.

This is $\frac{\log(X)}{\sqrt{X}} \sum \frac{a_p}{\sqrt{p}}$.
︡43c1b5f0-85e1-4895-a3b9-5b7c6fb745ae︡︡{"done":true,"md":"Multiplying the above by $\\sqrt{X}$ yields the **medium well data**. \n\nThis is $\\frac{\\log(X)}{\\sqrt{X}} \\sum \\frac{a_p}{\\sqrt{p}}$."}
︠a25e74fc-d12d-435b-afce-fd412161eb4es︠
t_sums2 = stats.TimeSeries([t_sums[i]*math.log(float(w[i]))/math.sqrt(float(w[i])) for i in range(len(t))])
︡93b3efb6-2a18-4a82-809a-97bdf7ccfb04︡︡{"done":true}
︠17bae5da-a464-40fe-b8c3-ede6ae58dbfcs︠
t_sums2.plot(figsize=[8,3], ymin=0)
︡42930857-f2ee-4a4b-9144-92c51d35f0fb︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"9fc8297a-1951-434c-9cad-cd7dec8240c4","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/31088/tmp_QoVYM0.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠5157a9d6-9a54-479d-b380-dfe8518c8080i︠
%md
Cesaro sum of the medium well data.  Since our curve has rank 0, I think we conjecture that this converges to $1$?

The actual data looks very stuck above $1$; it's amazing if it really does go down to 1...

Maybe that the variance -- which I plot below -- is still pretty big, should give us confidence.
︡43fead4c-78d8-4ede-892f-bbfaddff78c8︡︡{"done":true,"md":"Cesaro sum of the medium well data.  Since our curve has rank 0, I think we conjecture that this converges to $1$?\n\nThe actual data looks very stuck above $1$; it's amazing if it really does go down to 1...\n\nMaybe that the variance -- which I plot below -- is still pretty big, should give us confidence."}
︠3e2d143e-9568-410a-b075-5d26b4052036s︠
t_sums2_sums = t_sums2.sums()
t_sums2_sums_avg = stats.TimeSeries([t_sums2_sums[i]/(i+1) for i in range(len(t))])
︡c1b82e20-b896-4fb9-95e0-149d449247f4︡︡{"done":true}
︠9a3956ac-2069-4fce-91a8-455c800f7bb7s︠
t_sums2_sums_avg
︡04444705-8b53-4b90-af1e-93b0236cc963︡︡{"stdout":"[-0.6931, -0.9782, -1.0226, -1.1899, -1.2410 ... 1.1512, 1.1512, 1.1512, 1.1512, 1.1512]\n","done":false}︡{"done":true}
︠e2c09a66-35c0-4467-8c63-d2e03faa108fs︠
t_sums2_sums_avg.plot(figsize=[8,3], ymin=0, ymax=3) + line([(0,1), (len(t_sums2_sums_avg),1)], color='red')
︡5290e060-e82c-4d2e-9b05-ef73526d5da6︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"92bd1d94-202f-447c-9338-01fd5034ab27","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/31088/tmp_v6LLtE.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠605b0eb5-b46f-4753-ba10-f1ebb47b44eci︠
%md
Variance?  Here's the variance of the medium well data as a function of $X$ (the $x$-axis in the plot is $i$ so that $p_i = X$).

I'm just computing the variance of the first $100n$ terms of the sum as $n$ increases to $10^7$.
︡f383a09f-2cbb-49b2-ac0a-23050cb63a2e︡︡{"done":true,"md":"Variance?  Here's the variance of the medium well data as a function of $X$ (the $x$-axis in the plot is $i$ so that $p_i = X$).\n\nI'm just computing the variance of the first $100n$ terms of the sum as $n$ increases to $10^7$."}
︠14581fd5-0900-4c92-812a-f5ee47ce31ecs︠
%time t_sums2_var = stats.TimeSeries([t_sums2[:i*100].variance() for i in range(1,len(t_sums2)//100)])
︡8f64a9c3-56da-4ff6-b8fc-8c7eb2023af0︡︡{"stdout":"CPU time: 7.17 s, Wall time: 7.54 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}︡{"stdout":"CPU time: 7.35 s, Wall time: 7.64 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠9adc211a-61d8-4d21-946f-bab8b5e5db11s︠
t_sums2_var.plot(ymax=.35, figsize=[12,3])
︡6a7058aa-9fa3-47f4-8d99-1ed2c486a86c︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"dc041b6d-290b-4a8a-ac31-eaa01d8bd0d5","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/31088/tmp_Wtw_xf.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠27e6c096-202c-44ba-93fb-991519730f05s︠
# Double check: should be just like Cesaro  (yep)
%time t_sums2_mean = stats.TimeSeries([t_sums2[:i*100].mean() for i in range(1,len(t_sums2)//100)])
t_sums2_mean.plot(ymax=2, figsize=[12,3])  + line([(0,1), (len(t_sums2_mean),1)], color='red')
︡c69397f9-3691-4b60-b84f-237fb0982a3e︡︡{"stdout":"CPU time: 4.29 s, Wall time: 4.40 s","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"7ef05b19-b686-4476-af37-18b97121218e","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/31088/tmp_oiANas.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠1a4e2ac1-537d-4cfa-bb5c-d9554a720b9es︠
# significant variance even near the end... (these are the last 1000 terms)
t_sums2[-1000:].plot()
︡9ddf800a-66fa-419c-b30d-71a195e20589︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"60f657fe-4330-47b0-9b1f-a458577d25de","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/31088/tmp_EqYYVw.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠5b9cd08c-4cd9-4bcb-998d-dc25dd62fb05︠









