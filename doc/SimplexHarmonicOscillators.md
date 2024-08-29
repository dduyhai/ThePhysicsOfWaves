$$
\newcommand\lr[1]{\left(#1\right)}
$$

$$
\newcommand\Lr[1]{\left[#1\right]}
$$

$$
\newcommand\Exp[1]{\exp\lr{#1}}
$$

$$
\newcommand\Cos[1]{\mathrm{cos}\lr{#1}}
$$

$$
\newcommand\Sin[1]{\mathrm{sin}\lr{#1}}
$$

# Simple harmonic oscillators

## Damped oscilators

Consider the generic form for damped motion close to equilibrium:
$$
    \dfrac{d^2 x}{dt^2} + \gamma \dfrac{dx}{dt} + \omega_0^2 x = 0.
$$

$\Sin{x}$ is a function of x

Depending on relationship between $\omega_0$ and $\gamma$, we will have different damping behaviors:
* Underdamping when $\gamma < 2\omega_0$: the object oscilates but the amplitude slowly goes down in time.

* Overdamping when $\gamma > 2 \omega_0$: the object doesn't oscilate at all, and the amplitude exponentially decay.

* Critical damping when $\gamma = 2\omega_0$

For demonstation purpose we suppose that initial state stand still at some distance to the equilibrium state:
$$
    x\lr{0} = 1, \qquad \dfrac{dx}{dt}\lr{0} = 0.
$$

### Underdamping: $\gamma < 2 \omega_0$

Setting $\omega_u := \sqrt{\omega_0^2 - \lr{\dfrac{\gamma}{2}}^2}$, the general solution is
$$
    x\lr{t} = \Exp{-\dfrac{\gamma}{2} t} \Lr{C_1 \Exp{\imath \omega_u t} + C_2 \Exp{-\imath \omega_u t}}.
$$
Since $x \in \mathbb{R}$, $C_1 = C_2^*$ and $C_{1,2} := \dfrac{1}{2} A \Exp{\pm \imath \phi}$.
Hence
$$
    x\lr{t} = A \Exp{-\dfrac{\gamma}{2} t} \Cos{\omega_u t + \phi}.
$$
Using initial conditions, we have $A = 1$, $\phi = 0$ and the solution is
$$
    \boxed{x\lr{t} = \Exp{-\dfrac{\gamma}{2} t} \Cos{\omega_u t}}
$$

### Overdamping: $\gamma > 2 \omega_0$

Setting $u_{1,2} = \dfrac{\gamma}{2} \pm \sqrt{\lr{\dfrac{\gamma}{2}}^2 - \omega_0^2}$, the general solution is
$$
    x\lr{t} = C_1 \Exp{-u_1 t} + C_2 \Exp{u_2 t}.
$$
Initial conditions specify $C_{1,2}$ and lead to the specific solution
$$
    \boxed{x\lr{t} = \dfrac{u_2}{u_1 + u_2} \Exp{-u_1 t} + \dfrac{u_1}{u_1 + u_2} \Exp{u_2 t}}.
$$


### Critical damping $\gamma = 2 \omega_0$
The general solution is $x\lr{t} = \lr{C_1 + C_2 t} \Exp{-\omega_0 t}$.
Applying initial condition, the specific solution is
$$
    \boxed{x\lr{t} = \lr{1 + \omega_0 t} \Exp{-\omega_0 t}}.
$$
