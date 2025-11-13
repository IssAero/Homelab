# Setting up the ARR Stack:
Now that kubernetes is installed, we can get to work on setting up the ARR Stack (Jellyfin, Jellyseerr, qBittorrent, Prowlarr, Sonarr, Radarr) - These are the apps I've decided to run on my homelab, but any alternatives will be very similar to set up.

⚠️**Make sure you edit all of the .yaml manifest files with your values and don't leave any placeholders, this will 100% give you headaches if you don't.**⚠️

🟢 I've followed https://trash-guides.info/ for setting up the directory structure / user permissions / app configs.  Hardliking will work with this setup, you don't need to make any changes to the deployments VolumeMounts / PVCs / PVs.

## NFS and Media Storage
First things first, we need to start with creating the PV and PVC for media storage and the 'media' namespace - the first iterations had separate VolumeMounts for both the downloads and the media, which unfortunately inhibit our stack from hardlinking the files, and this results in doubling the space used by our media, due to copies being made instead of hardlinks.

```
cd /Homelab/K3s/Volumes

kubectl create ns media

kubectl apply -f media-storage-pv-and-pvc.yaml
```

⚠️ I've chosen **/data** as the directory on my media-node where I'd like to have my **/torrents** and **/media** libraries - you'll have to make sure this folder exists on the node hosting these.
You'll have to export the /data NFS directory is exported in your /etc/exports: ```sudo nano /etc/exports```

Make sure to add the following line:
```
/data *(rw,sync,no_subtree_check,no_root_squash)
```
Change the permissions for **/data** so that the user we'll be using to run these apps has access:
```
sudo groupadd -g 1057 mediaapps
sudo useradd -u 1056 -g 1057 -m -s /usr/sbin/nologin jellyfinapp

sudo chown -R 1056:1057 /data
sudo chmod -R a=,a+rX,u+w,g+w /data
```
Then re-export:
```
sudo exportfs -ra
```

## App PVCs
Next step is creating the PVCs for each of the app we'll be running. These will only store the config files, and so they don't need a lot of storage:
```
cd /Homelab/K3s/Volumes/longhorn-volumes && ls

kubectl apply -f jellyfin-config-pvc.yaml
kubectl apply -f jellyseer-config-pvc.yaml
(continue for all)
```
# Networking

Initially I've tried running this setup using a Cloudflare DDNS pod and proxying my services to main subdomain on cloudflare - this worked initially for some time until my IPS decided to move me behind a CGNAT which unfortunately broke my setup.

The workaround I've come up with is using a Cloudflared tunnel which is done quite simply with a deployment:

## Cloudflared
You'll need to follow these steps from the official Cloudflare docs in order to setup the tunnel: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/

After setting up the tunnel, select the operating system 'Docker' and you'll be provided with a token, make a note of it, we'll be storing it in a secret on our cluster. We'll be creating a separate namespace for the Cloudflared pod and we'll be storing the token in a secret to use later for the Cloudflared deployment.
```
kubectl create namespace cloudflare-tunnel

kubectl create secret generic cloudflared-token \
  --from-literal=token='<YOUR-TUNNEL-TOKEN>' \
  -n cloudflare-tunnel
```
Time to deploy Cloudflared:
```
cd /Homelab/K3s/ARR/Deployments
kubectl apply -f cloudflared-deployment.yaml
```
Make sure everything is working before continuing ( *kubectl get pods -n cloudflare-tunnel* ).

## Services / Ingress / Cert-Manager

### Services
We'll be creating services for all of our apps in order to expose them to the cluster network, and mapping all of their ports to port 80 for simplicity. 

```
cd /Homelab/K3s/ARR/Services

kubectl apply -f jellyfin-service.yaml
kubectl apply -f jellyseer-service.yaml
(continue for all)
```
### Cert-Manager
Now we'll need to install Cert-Manager in order to get certificates for our apps.
You need to manually create this Secret in the same namespace where cert-manager is running (often cert-manager):
```
kubectl create secret generic cloudflare-api-token-secret \
  --from-literal=api-token=<your_cloudflare_api_token> \
  --namespace cert-manager
```
In your ClusterIssuer YAML, make sure:
<li>The email: is the one you registered with Let's Encrypt
<li>The api-token: has Zone:DNS Edit and Zone:Read permissions for the relevant domains

<br>
If you haven’t installed cert-manager yet:

```kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml```

Or install via Helm if you're customizing it

<br>

After ensuring the secret is present and that Cert-Manager is installed, you can apply your ClusterIssuer.yaml (edit this with your domain/subdomains) and your media-suite-certificate. (One will create your Cluster Certificate Issuer, and the other will create the certificates)

```
cd /Homelab/K3s/ARR/Certificates
kubectl apply -f ClusterIssuer.yaml
kubectl apply -f media-suite-certificate.yaml
```
### Ingress

Ingress will be the one doing all the heavy lifting, meaning sending the traffic outside of our cluster network, exposing pods to outside traffic.

Make sure the ingress controller is up-and-running: ```kubectl get pods -n ingress-nginx```

If the ingress-controller is healthy, then we can apply the ingress manifest:

```
cd /Homelab/K3s/ARR/Ingresses/arr-ingresses.yaml

kubectl apply -f arr-ingresses.yaml
```

# Deployments
The final part of deploying the applications is ... well... deploying them 😊. <br>
If you've followed my steps this far, you can apply the deployments without any edits being needed (**If you've kept the same directory naming scheme**)

```
cd /Homelab/K3s/ARR/Deployments

kubectl apply -f jellyfin-deployment.yaml
kubectl apply -f jellyseer-deployment.yaml
(continue for all, except Cloudflared, we've deployed that earlier)
```

With any luck, all of the application pods will be up-and-running and healthy. Last thing that's needed before you can connect to your applications is setting up the Public Hostnames inside the Cloudflare Dashboard > ZeroTrust > Networks > Tunnels and choose the one you've set up earlier.

Here you'll need to specify the subdomain/domain you'd like to use. For Service, type needs to be HTTP since we're exposing port 80 on our cluster and for URL, we'll need to use the FQDN of our pod with the port it is using (80 in our case, as mentioned earlier)

### Create a Public Hostname for all of your apps, and that's it! You should now be able to access your apps using your domain! 🎉🎉

🟢**For setting up the ARR applications and configurations, you can take a look at https://trash-guides.info/**