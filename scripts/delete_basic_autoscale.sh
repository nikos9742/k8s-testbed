#!/bin/bash
#!!! DELETE !l scale CPU testbed k8s using HPA and basic CPU values 
 

kubectl delete hpa adservice
kubectl delete hpa cartservice
kubectl delete hpa checkoutservice
kubectl delete hpa currencyservice
kubectl delete hpa emailservice
kubectl delete hpa frontend
kubectl delete hpa loadgenerator
kubectl delete hpa paymentservice 
kubectl delete hpa productcatalogservice
kubectl delete hpa recommendationservice
kubectl delete hpa redis-cart
kubectl delete hpa shippingservice

kubectl scale -n default deployments adservice  --replica=1                
kubectl scale -n default deployments cartservice --replica=1            
kubectl scale -n default deployments checkoutservice --replica=1       
kubectl scale -n default deployments currencyservice --replica=1        
kubectl scale -n default deployments emailservice --replica=1           
kubectl scale -n default deployments frontend --replica=1               
kubectl scale -n default deployments loadgenerator --replica=1          
kubectl scale -n default deployments paymentservice --replica=1         
kubectl scale -n default deployments productcatalogservice --replica=1  
kubectl scale -n default deployments recommendationservice --replica=1  
kubectl scale -n default deployments redis-cart --replica=1             
kubectl scale -n default deployments shippingservice --replica=1 