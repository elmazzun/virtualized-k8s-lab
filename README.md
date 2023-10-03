# Virtual Kubernetes development lab

⚠️⚠️⚠️

This repository is Work in Progress: as long as you see this paragraph **do not clone this repo**.

⚠️⚠️⚠️

## What is this?

This is an attempt to configure a Debian VM where you can write, develop and 
test modifications against a local Kubernetes cluster provisioned in such VM: 
once I'll complete this work, you should be able to have a working environment 
with which you could contribute to Kubernetes project.

# How does it works?

First of all, you are required to clone Kubernetes repository in the same folder 
level of this repository.

You'll also need [Vagrant](https://www.vagrantup.com) and [Virtualbox](https://www.virtualbox.org/).

To provision the VM, just run `vagrant up`.
