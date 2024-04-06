# Secure SSH Configuration for Fly.io

This guide shows how to set up an ssh server on fly.io machine (for various use like remote vscode).

- The docker image and docker-entrypoint are already set up. 
- You can modify the docker image to your liking.

### Step 0: Launch a fly.io app
Follow the fly.io guides to launch an app:

```bash
fly launch
```

### Step 1: Generate an SSH Key Pair on your local machine
Generate a new SSH key pair by running the following command (more secure):

   ```bash
   ssh-keygen
   ```

Set a secure passphrase when prompted for enhanced security (optional but recommended).

==my ssh key is named `id_flyvm`, make sure to name yours when running ssh-keygen or pay attention to its generated name==

### Step 2: Add the SSH Public Key to Fly.io Secrets
After generating your SSH key pair, add your public key to Fly.io's secrets to allow for authentication. Replace id_flyvm.pub with your public key file name if different:

```bash
fly secrets set "AUTHORIZED_KEYS=$(cat ~/.ssh/id_flyvm.pub)"
```

Ensure you are in the correct Fly.io project directory or specify the project name with -a <app-name>.

### Step 3: Deploy the machine

```bash
fly deploy
```

### Step 4: Connect via IPv6 Using SSH
First allocate an IPv6 address for your Fly.io app:

```bash
fly ips allocate-v6
```
it's a free and dedicated IPv6 address, that way you don't have to pay for a dedicated IPv4 (this won't work with a shared IPv4 address).

Use the private key to establish an SSH connection. Replace the IPv6 address with your server's IPv6 address:

```bash
ssh -v -i ~/.ssh/id_flyvm root@<ipv6-address>
```

The -v flag enables verbose mode to help troubleshoot connection issues.

If connecting for the first time, you'll be prompted to verify the server's fingerprint. Type yes to continue.

Note: Ensure your server is configured to accept SSH connections and the IPv6 firewall rules allow for incoming connections on port 22.

### Troubleshooting
If you encounter "Permission denied" errors, double-check the permissions of your private key file (chmod 600 ~/.ssh/id_flyvm) and ensure the public key has been correctly added to Fly.io.
For "No route to host" errors, verify your local and server IPv6 connectivity and ensure no firewalls are blocking the SSH port.
For more information on SSH and Fly.io configurations, visit Fly.io Docs.