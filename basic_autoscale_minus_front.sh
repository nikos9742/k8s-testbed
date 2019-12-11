#!/bin/bash
#autoscale -n default deployments CPU testbed k8s using HPA and basic CPU values

kubectl autoscale -n default deployments adservice  --cpu-percent=50 --min=2 --max=20                
kubectl autoscale -n default deployments cartservice --cpu-percent=50 --min=2 --max=20            
kubectl autoscale -n default deployments checkoutservice --cpu-percent=50 --min=2 --max=20       
kubectl autoscale -n default deployments currencyservice --cpu-percent=50 --min=2 --max=20        
kubectl autoscale -n default deployments emailservice --cpu-percent=50 --min=2 --max=20           
#kubectl autoscale -n default deployments frontend --cpu-percent=50 --min=1 --max=20               
kubectl autoscale -n default deployments loadgenerator --cpu-percent=50 --min=2 --max=20          
kubectl autoscale -n default deployments paymentservice --cpu-percent=50 --min=2 --max=20         
kubectl autoscale -n default deployments productcatalogservice --cpu-percent=50 --min=2 --max=20  
kubectl autoscale -n default deployments recommendationservice --cpu-percent=50 --min=2 --max=20  
kubectl autoscale -n default deployments redis-cart --cpu-percent=50 --min=2 --max=20             
kubectl autoscale -n default deployments shippingservice --cpu-percent=50 --min=2 --max=20    
