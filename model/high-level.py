def SA(m, IV):
    # State Array function
    H = [0] * 4
    for i in range(4):
        H[i] = m[i] ^ IV[i]
        print("H[i] in SA:", H[i])
    print("\n")
    return H

def Theta(H):
    # Permutation function (Θ)
    H_theta = [0] * 4
    for i in range(4):
        H_theta[i] = H[3 - i]
    return H_theta

def rho(H):
    # ρ function
    for i in range(4):
        temp = (H[i] + 0x85) & 0xFF
        print("temp", temp)
        H[i] = temp % 0xFD
    return H

def FPX(H, IV):
    # Final Permutation and Xoring function
    d = [0] * 4
    for i in range(4):
        d[i] = H[3 - i] ^ IV[i]
    return d

def hash_function(m, IV, rounds=24):
    H = None
    for r in range(rounds):
        if r == 0:
            H = SA(m, IV)
        else:
            # XOR with IV
            H = [H[i] ^ IV[i] for i in range(4)]
            print("XOR:", H)
        # Apply Theta
        H = Theta(H)
        print("Theta:", H)
        # Apply ρ function
        H = rho(H)
        print("Rho:", H)
    # Calculate digest d
    d = FPX(H, IV)
    return d

def read_message():
    while True:
        try:
            message = input("Inserisci un messaggio di 4 byte (es. 01 02 03 04): ")
            m = [int(x, 16) for x in message.split()]
            if len(m) != 4:
                raise ValueError
            return m
        except ValueError:
            print("Input non valido. Assicurati di inserire esattamente 4 byte in formato esadecimale.")

# Example usage:
IV = [0x34, 0x55, 0x0F, 0x14]  # Initialization Vector (4 bytes)

m = read_message()
digest = hash_function(m, IV)
print("Digest:", digest)

m1 = read_message()
digest = hash_function(m1, IV)
print("Digest:", digest)