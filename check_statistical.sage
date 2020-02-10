from sage.rings.polynomial.polynomial_gf2x import GF2X_BuildIrred_list


def create_mds_prime(F, t, start):
    M = matrix(F, t, t)
    xs = []
    ys = []

    for i in range(0, t):
        xs.append(F(start + i))
        ys.append(F(start + t + i))

    for i in range(0, t):
        for j in range(0, t):
            entry = (xs[i] + ys[j]) ^ (-1)
            M[i, j] = entry
    return M


def create_mds_binary(F, t, start):
    M = matrix(F, t, t)
    xs = []
    ys = []

    for i in range(0, t):
        xs.append(F.fetch_int(start + i))
        ys.append(F.fetch_int(start + t + i))

    for i in range(0, t):
        for j in range(0, t):
            entry = (xs[i] + ys[j]) ^ (-1)
            M[i, j] = entry
    return M


def one_hot(a, n, F):
    v = [F(0)] * n
    v[a] = F(1)
    return v

def evaluate(pattern, a, t, mat, F):
    state = matrix(F, t, t + a)
    E = matrix(F, len(pattern), t + a)
    for i in range(t):
        state[i, i] = F(1)

    s = 0
    row = 0
    for r in range(len(pattern)):
        # sbox layer
        if pattern[r] == 1:
            # active sbox
            state[0, :] = vector(one_hot(t + s, t + a, F))
            s += 1

        else:
            # no active sbox
            E[row, :] = state[0, :]
            row += 1

        # linear layer
        state = mat * state

    basis = kernel(E.T).basis()
    l = len(basis)

    if l == 0:
        return True

    return False



def search(pattern, s, a, i, t, MDS, F):
    n = len(pattern)

    if i >= n - 2:
        if not evaluate(pattern, a, t, MDS, F):
            print(pattern)
        return

    if i < t + 2*s - 1:
        pattern[i] = 0
        search(pattern, s, a, i + 1, t, MDS, F)

    if s < a and 2 * s < i - 1:
        # we may activate an s-box
        pattern[i] = 1
        search(pattern, s + 1, a, i + 1, t, MDS, F)

def main(b_or_p, n, t, start, end, lin):
    
    if b_or_p == 'bin':
        irred = GF(2)['x'](GF2X_BuildIrred_list(n))
        F.< x > = GF(2**n, name='x', modulus=irred)
        MDS = create_mds_binary(F, t, 0)
    elif b_or_p == 'prime':
        F = GF(n)
        MDS = create_mds_prime(F, t, 0)
    else:
        print(err_msg)
        return
    
    if lin:
        MDS = (MDS.T).inverse()

    for a in range(start, end):
        n = t + 2 * a
        print('start {0}'.format(a))
        search([0] * n, 0, a, 2, t, MDS, F)
        print('end {0}'.format(a))


if __name__ == '__main__':
    err_msg = 'Usage: check_statistical.sage <bin/prime> <n/p> <t> <start> <end> (<lin>)'
    args = sys.argv
    if len(args) == 6:
        main(args[1], int(args[2]), int(args[3]), int(args[4]), int(args[5]), 0)
    if len(args) == 7:
        main(args[1], int(args[2]), int(args[3]), int(args[4]), int(args[5]), 1)
    else:
        print(err_msg)

