
def SA(m, IV):
    # State Array function
    H = [0] * 4
    for i in range(4):
        H[i] = m[i] ^ IV[i]
    return H

def Theta(H):
    # Permutation function (Θ)
    H_theta = [0] * 4

    for i in range(4):
        H_theta[i] = H[3-i]

    return H_theta

def rho(H):
    # ρ function
    # Reverse the array
    H = H[::-1]      
    # Add 0x85 and modulo 0xFD
    for i in range(4):
        H[i] = (H[i] + 0x85) % 0xFD
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

            
        #Apply Theta
        H = Theta(H)
        # Apply ρ function
        H = rho(H)
    
    # Calculate digest d
    d = FPX(H, IV)
    return d

# Example usage:
m = [0x01, 0x02, 0x03, 0x04]  # Example message block (4 bytes)
IV = [0x34, 0x55, 0x0F, 0x14]  # Initialization Vector (4 bytes)

digest = hash_function(m, IV)
print("Digest:", digest)
