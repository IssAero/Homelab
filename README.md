### work in progress.

# Kubernetes Homelab 🖥️

## Intro / Why build a homelab with Kubernetes?

I felt that as someone trying to break into the DevOps market, my choices were pretty limited and I felt stuck at times: My job wasn't too technical and I wanted to learn more technologies, so I applied to more technical positions. They end up choosing someone with more experience. So I'm back at square one. This probably sounds familiar, so I decided I'd get the experience needed on my own.

Having played around with a homelab before, only running containers on it, I took a CKAD course and decided that this would be a great project to get hands on experience.

And so the lab was built using [Packer](https://developer.hashicorp.com/packer), [Terraform](https://developer.hashicorp.com/terraform), [Proxmox VE](https://www.proxmox.com/en/), [K3s](https://k3s.io/) and a lot of yaml 📄


## Part I - Proxmox / Packer / Terraform

I wanted to automate as much as I could and introduce as many technologies as I could, whilst also learning along the way. So I ended up installing Proxmox as my Hypervisor in order to have multiple nodes for Kubernetes (I saw using the control node as a worker pretty pointless and decided it would be best to create multiple VMs/Nodes).

### Proxmox:
Nothing too crazy here, just installed proxmox on my bare metal server, mounted my HDDs and installed a couple programs in order to make my life easier (Tailscale for remote management).

### Packer:
After messing around a bit with some cloud-init images I tried creating myself, I decided this to be a pretty laborous task, and quickly found Packer as an alternative - I followed Christian Lempa's video on Packer and had my own Ubuntu cloud-init image running in no time.

I feel this is a very good addition to this setup, as this allows me to create an image of any distro i'd like in a couple of minutes, without any manual input. (plus HCL experience is always nice)

Also as a note, I recommend installing Packer and running the Packer code directly from the Bare Metal host, as during the image creation process, a web server will be opened for the VM-to-be-turned-template to connect to and for as little headache as possible, it is just easier to let localhost do it's thing.

### Terraform:
For terraform I used the Telmate provider - which works well with what I was trying to do - It wasn't perfect, for example, one limitation I found is that you'll need to use one machine in order to execute the terraform code and keep using it in order to have an accurate state file, because apparently trying to import will cause this provider to crash. 
Other than the issue above, everything works very well and I was able to provision and edit my VMs/Nodes to my liking without much hassle.


## ☸️ Part II - Kubernetes 

### Intro to K3s:
By far the step that took the longest - a lot of trial and error happened here, mainly due to being a new technology I haven't used before and took some getting used to - but also due to trying to choose the best plugins to use with K3s for this use case.

I wanted to disable the default network plugin, which was Flannel, due to it being quite 'old' and not having any RBAC or network policy possibilities (I haven't set up any as of now, but you never know what the future holds) and I've also disabled Traefik, the default ingress that K3s uses.

The reason for disabling Traefik and Flannel are mainly because there is not as much support for those as there is for Calico (CNI) and NGINX Ingress - both of which are the alternatives I've chosen to install on my cluster.